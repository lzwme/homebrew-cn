class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://ghfast.top/https://github.com/plutoprint/plutobook/archive/refs/tags/v0.11.3.tar.gz"
  sha256 "699cd4a645548b7f96dd3bfab4a602ab694f085473ff44d8812d690efb3c6e3e"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8cfacbfba13e44125bbdcf72aa6ef07324ad20e30344598a4bd4d0cc12381865"
    sha256 cellar: :any, arm64_sequoia: "d1e6fca04a03899c93ff3490f67c13c8d01caae50fe418da68371ad462169542"
    sha256 cellar: :any, arm64_sonoma:  "0082fea74b8df4ed8fb80220b92cbd6f10bee488126d25ec9e088ee5b07cfa50"
    sha256 cellar: :any, sonoma:        "c0a7a530597d5781d985eb99bcff8c170a4082e13613c67d8e5e9c5dc21757da"
    sha256               arm64_linux:   "b51cf7d524e074fdd4d50c704f3b51d5188e52ea95cb07ee14a8b99a0b67d5fb"
    sha256               x86_64_linux:  "74e537f3f3fbd1dfc7b6a31344e542b2f8d34ee36a19af5062b03b2d7e2a9858"
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