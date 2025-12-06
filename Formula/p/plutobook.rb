class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://ghfast.top/https://github.com/plutoprint/plutobook/archive/refs/tags/v0.11.2.tar.gz"
  sha256 "70000ed4b438a683cea1d5e4eea42bc975f7076f56b402927a2a332f13bc1d77"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f5ffbd8860de17503252d62dca4e50fe409711ac9c338c6c809b2e0bc5162564"
    sha256 cellar: :any, arm64_sequoia: "b15efdeceb15a14669b92feaeaedba5e0ca5f7fe2b070883cf127244e8984c3d"
    sha256 cellar: :any, arm64_sonoma:  "999383979d66ea79fa64e140a904ff4cbed13ab23d16139d2681bb5b838b2185"
    sha256 cellar: :any, sonoma:        "2fd1b9724d0e0be4d65538fbf92fe73ffcf92797d469eb570366a6dd66867381"
    sha256               arm64_linux:   "49939a4b7c1de8f616a2c13375a02bab1db751412063b0b7473b7413bafa1455"
    sha256               x86_64_linux:  "f27095ea6ec02ddb47c62018b1c584a80bdcb3072f9c32e66472a49b43e51e24"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "cairo"
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "harfbuzz"
  depends_on "icu4c@78"
  depends_on "jpeg-turbo"
  depends_on "libidn2"
  depends_on "webp"
  uses_from_macos "expat"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1499
  end

  on_ventura do
    depends_on "llvm" => :build
  end

  fails_with :clang do
    build 1499
    cause "Requires C++20 support"
  end

  fails_with :gcc do
    version "9"
    cause "requires GCC 10+"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <plutobook/plutobook.hpp>

      static const char kHTMLContent[] = R"HTML(
      <!DOCTYPE html>
      <html>
      <body>Hello!</body>
      </html>
      )HTML";

      int main() {
        plutobook::Book book(plutobook::PageSize::A4, plutobook::PageMargins::Narrow);
        book.loadHtml(kHTMLContent);
        book.writeToPdf("test.pdf");
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-I#{include}", "-L#{lib}", "-lplutobook", "-o", "test"
    system "./test"
    assert_path_exists testpath/"test.pdf"
  end
end