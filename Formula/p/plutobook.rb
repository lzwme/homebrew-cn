class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://ghfast.top/https://github.com/plutoprint/plutobook/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "770349857d4480930e273672ed45ae4d9be2ed5d6bca441823e3031dd09a5ebc"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "882bdf74e8073bd1ec24bad089212251ca2c42729b86bccf00c412c4846e5589"
    sha256 cellar: :any, arm64_sequoia: "8340d5748629dac9b11074ea77ecee2589986e20988aaea476ba9a598b605dcb"
    sha256 cellar: :any, arm64_sonoma:  "e3860f587ee0cad59ee463db79c0122885a7009120177907ff3942f0910af733"
    sha256 cellar: :any, sonoma:        "2e663d9ffc6aab28035eaebbb2f3e84aa7a1ab716ed479dc65faa68a4fe34316"
    sha256               arm64_linux:   "48794b8ceef5a0959352e42a4609e831cf77adcf268715e2af8a03a01507b1cd"
    sha256               x86_64_linux:  "948fbc50f95c60d24cf3caff4f8af72b46bcc754f15cf9ba612449612d8f368e"
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