class Mavsdk < Formula
  include Language::Python::Virtualenv

  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v1.4.17",
      revision: "34b0c051f70b7018e3d98c2fe0e78677d4c3af14"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e9a3c2a021f6575d3aceec52ff1a403e2d08acf43ddf203837c8205d16203615"
    sha256 cellar: :any,                 arm64_ventura:  "796e98d0242a9b2dd270dcfd6e98e49259d2858753c37ef8ec929f668a99097e"
    sha256 cellar: :any,                 arm64_monterey: "165aa34a876b6aeda2dcf4bb2e97a9815d5bb8a0baf77dc60b01397c2f651e69"
    sha256 cellar: :any,                 sonoma:         "0f211eb0fe4dbbfdbb23ba9e5127de0467ed02fb95cff364da85e5e64a2ad810"
    sha256 cellar: :any,                 ventura:        "9db9ecdc2c2254afebcbedd81ae6c8bbc028fb6163059ee1196b204a2a96d713"
    sha256 cellar: :any,                 monterey:       "f6f9b724d0ae244cec00ecd916b95e4696d44d238424229ac6cdca168166c926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69c5fba0ede0c8b8ac4f484c210b3d2f770b349505903d1dc97b8d1ac224b78c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build
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
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  def install
    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Install protoc-gen-mavsdk deps
    venv_dir = buildpath/"bootstrap"
    venv = virtualenv_create(venv_dir, "python3.11")
    venv.pip_install resources

    # Install protoc-gen-mavsdk
    venv.pip_install "proto/pb_plugins"

    # Run generator script in an emulated virtual env.
    with_env(
      VIRTUAL_ENV: venv_dir,
      PATH:        "#{venv_dir}/bin:#{ENV["PATH"]}",
    ) do
      system "tools/generate_from_protos.sh"

      # Source build adapted from
      # https://mavsdk.mavlink.io/develop/en/contributing/build.html
      system "cmake", *std_cmake_args,
                      "-Bbuild/default",
                      "-DSUPERBUILD=OFF",
                      "-DBUILD_SHARED_LIBS=ON",
                      "-DBUILD_MAVSDK_SERVER=ON",
                      "-DBUILD_TESTS=OFF",
                      "-DVERSION_STR=v#{version}-#{tap.user}",
                      "-DCMAKE_INSTALL_RPATH=#{rpath}",
                      "-H."
    end
    system "cmake", "--build", "build/default"
    system "cmake", "--build", "build/default", "--target", "install"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <mavsdk/mavsdk.h>
      int main() {
          mavsdk::Mavsdk mavsdk;
          std::cout << mavsdk.version() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", testpath/"test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lmavsdk"
    assert_match "v#{version}-#{tap.user}", shell_output("./test").chomp

    assert_equal "Usage: #{bin}/mavsdk_server [Options] [Connection URL]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end