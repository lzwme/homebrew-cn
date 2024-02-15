class Mavsdk < Formula
  include Language::Python::Virtualenv

  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https:mavsdk.mavlink.io"
  url "https:github.commavlinkMAVSDK.git",
      tag:      "v1.4.18",
      revision: "b87a21d9044b9385e570fe0dd3389b74a3d52c2d"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "da5786b374b16751bd13f4257feb1b021ef1cf89e247c510f55f170258a08d7e"
    sha256 cellar: :any,                 arm64_ventura:  "5f65504273ae73e0786474ebfecc714d3f4a6aead229103c9c0a5691460fb200"
    sha256 cellar: :any,                 arm64_monterey: "ca0b8f66f1a39eded141b06987d75e787e4f188268dc58e47768cbec98226fc9"
    sha256 cellar: :any,                 sonoma:         "82a63ac1be10f8ccda6d9eb47cba560b80d7e4ed2b694f0f1a1181407037f650"
    sha256 cellar: :any,                 ventura:        "f1a63e694bbf4ea58807126acc689de471e1330efdde4fe0dd5854f2d9aed444"
    sha256 cellar: :any,                 monterey:       "9aad9cfb44617365fe12a1467bd4c26c6acad8627fb2689dc90400233f30ca26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eedab17e4177a971556ae8fefc2fc21f8843cbf29973a6960ae16b962337c1dd"
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