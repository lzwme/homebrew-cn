class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https:www.sfml-dev.org"
  url "https:www.sfml-dev.orgfilesSFML-3.0.0-sources.zip"
  sha256 "8cc41db46b59f07c44ecf21c74a0f956d37735dec9d90ff4522856cb162ba642"
  license "Zlib"
  head "https:github.comSFMLSFML.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a4f2a550dbf8f0c738a0039806aac58e953715dd805ecca883c592d5a483a055"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "678b1824ead3b9369afab1951dcbcd49615065af6667c1080d9129feafc1ee71"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24af4cff3a8441b1630e4eda8603b610a45d22ab22d11b78d0749ef47b3be276"
    sha256 cellar: :any_skip_relocation, sonoma:        "4d5cde2d922d35bc77ed993e51785f882fc837e9e5a662462f10870c3f8a595f"
    sha256 cellar: :any_skip_relocation, ventura:       "4465dd4a2c23ee8ee49005cfe6bb143d1b85b820afef770b31477324de854790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8af3036c52506067f3418e28926596831d6c304fe06a57318cdb11a1a9d55337"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
    depends_on "libxi"
    depends_on "libxrandr"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "openal-soft"
    depends_on "systemd"
  end

  def install
    # Fix "fatal error: 'osavailability.h' file not found" on 10.11 and
    # "error: expected function body after function declarator" on 10.12
    # Requires the CLT to be the active developer directory if Xcode is installed
    ENV["SDKROOT"] = MacOS.sdk_path if OS.mac? && MacOS.version <= :high_sierra

    # Always remove the "extlibs" to avoid install_name_tool failure
    # (https:github.comHomebrewhomebrewpull35279) but leave the
    # headers that were moved there in https:github.comSFMLSFMLpull795
    rm_r(Dir["extlibs*"] - ["extlibsheaders"])

    args = ["-DCMAKE_INSTALL_RPATH=#{lib}",
            "-DSFML_MISC_INSTALL_PREFIX=#{share}SFML",
            "-DSFML_INSTALL_PKGCONFIG_FILES=TRUE",
            "-DSFML_BUILD_DOC=TRUE",
            "-DSFML_USE_SYSTEM_DEPS=ON"]

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--build", "build", "--target=doc"
    system "cmake", "--install", "build"
  end

  test do
    (testpath"test.cpp").write <<~CPP
      #include "Time.hpp"
      int main() {
        sf::Time t1 = sf::milliseconds(10);
        return 0;
      }
    CPP
    system ENV.cxx, "-I#{include}SFMLSystem", "-std=c++17", testpath"test.cpp",
           "-L#{lib}", "-o", "test"
    system ".test"
  end
end