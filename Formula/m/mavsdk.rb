class Mavsdk < Formula
  include Language::Python::Virtualenv

  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https:mavsdk.mavlink.io"
  url "https:github.commavlinkMAVSDK.git",
      tag:      "v1.4.18",
      revision: "b87a21d9044b9385e570fe0dd3389b74a3d52c2d"
  license "BSD-3-Clause"
  revision 5

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4658cb2cbd0dd8d1bc0c639b41759612cef41e2ba1eaef689c5f7ef9e72e42d7"
    sha256 cellar: :any,                 arm64_ventura:  "d635b1f0e4b1f703e41a9bcfdc3c94f285ff770ae6596b89a13dd975e585464c"
    sha256 cellar: :any,                 arm64_monterey: "3f89341e7532108b86e0c66fc0266a8062d74f2a5d459c0b0964a9f0474c957e"
    sha256 cellar: :any,                 sonoma:         "f804341145db2b1271e9cbc28ed85df4e0cf82ae869682226800ed1f4c368419"
    sha256 cellar: :any,                 ventura:        "598d1e149c97e651bc678246e7902f044f97ac385689a4a38eb08a63fab0c8fe"
    sha256 cellar: :any,                 monterey:       "cbf3d3d8e068e67b9673f0c62ea27c43d314bfa76072b9b4486c4db218cb9341"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abf06caccb01c44f46c889c74ac1927b02d6b6131296cc67399cce285e7b855f"
  end

  depends_on "cmake" => :build
  # `future` issue ref: https:github.comPythonCharmerspython-futureissues625
  # `pymavlink` PR ref to remove `future`: https:github.comArduPilotpymavlinkpull830
  depends_on "python@3.11" => :build # Python 3.12 blocked by imp usage in `future` used by pymavlink
  depends_on "six" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "curl"
  depends_on "grpc"
  depends_on "jsoncpp"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "tinyxml2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__status(std::__1::__fs::filesystem::path const&, std::__1::error_code*)"
    EOS
  end

  fails_with gcc: "5"

  # To update the resources, use homebrew-pypi-poet on the PyPI package `protoc-gen-mavsdk`.
  # These resources are needed to install protoc-gen-mavsdk, which we use to regenerate protobuf headers.
  # This is needed when brewed protobuf is newer than upstream's vendored protobuf.
  resource "future" do
    url "https:files.pythonhosted.orgpackages8f2ecf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ecfuture-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "Jinja2" do
    url "https:files.pythonhosted.orgpackages7aff75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cceJinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https:files.pythonhosted.orgpackages6d7c59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbfMarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  def install
    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Install protoc-gen-mavsdk deps
    venv_dir = buildpath"bootstrap"
    venv = virtualenv_create(venv_dir, "python3.11")
    venv.pip_install resources

    # Install protoc-gen-mavsdk
    venv.pip_install "protopb_plugins"

    # Run generator script in an emulated virtual env.
    with_env(
      VIRTUAL_ENV: venv_dir,
      PATH:        "#{venv_dir}bin:#{ENV["PATH"]}",
    ) do
      system "toolsgenerate_from_protos.sh"

      # Source build adapted from
      # https:mavsdk.mavlink.iodevelopencontributingbuild.html
      system "cmake", *std_cmake_args,
                      "-Bbuilddefault",
                      "-DSUPERBUILD=OFF",
                      "-DBUILD_SHARED_LIBS=ON",
                      "-DBUILD_MAVSDK_SERVER=ON",
                      "-DBUILD_TESTS=OFF",
                      "-DVERSION_STR=v#{version}-#{tap.user}",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      "-H."
    end
    system "cmake", "--build", "builddefault"
    system "cmake", "--build", "builddefault", "--target", "install"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    (testpath"test.cpp").write <<~EOS
      #include <iostream>
      #include <mavsdkmavsdk.h>
      int main() {
          mavsdk::Mavsdk mavsdk;
          std::cout << mavsdk.version() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", testpath"test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lmavsdk"
    assert_match "v#{version}-#{tap.user}", shell_output(".test").chomp

    assert_equal "Usage: #{bin}mavsdk_server [Options] [Connection URL]",
                 shell_output("#{bin}mavsdk_server --help").split("\n").first
  end
end