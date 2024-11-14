class Sfml < Formula
  # Don't update SFML until there's a corresponding CSFML release
  desc "Multi-media library with bindings for multiple languages"
  homepage "https:www.sfml-dev.org"
  url "https:www.sfml-dev.orgfilesSFML-2.6.2-sources.zip"
  sha256 "19d6dbd9c901c74441d9888c13cb1399f614fe8993d59062a72cfbceb00fed04"
  license "Zlib"
  head "https:github.comSFMLSFML.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dad951fee57489386b190487b5618f951d8fc6dac4f4dd52b8a6d4803c431312"
    sha256 cellar: :any,                 arm64_sonoma:  "1048b1b45f046e04ba0315e2897385975beda5aa9c66c964df3ee934d744b46d"
    sha256 cellar: :any,                 arm64_ventura: "9c017c1f6caf97f54ecc06b9c86ce65a5e3b70ec6a1d2d61c61ddb0e8b2ae255"
    sha256 cellar: :any,                 sonoma:        "37ea58ff8e945e950cb4f41c17947ccb09d1f844d2d3b3e2422b3cbefa6d3832"
    sha256 cellar: :any,                 ventura:       "e60f193727509cc7f80fb52cc4cb7cfff9df3b86fea68d4322dd3d68ccc4cc79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "266b693f97a6ebffefc662517d1805b2ce00dd6383a9488e4d760d89afc819f5"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libvorbis"

  on_linux do
    depends_on "libx11"
    depends_on "libxcursor"
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
            "-DSFML_BUILD_DOC=TRUE"]

    args << "-DSFML_USE_SYSTEM_DEPS=ON" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
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
    system ENV.cxx, "-I#{include}SFMLSystem", testpath"test.cpp",
           "-L#{lib}", "-lsfml-system", "-o", "test"
    system ".test"
  end
end