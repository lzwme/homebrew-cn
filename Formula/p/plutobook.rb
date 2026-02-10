class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://ghfast.top/https://github.com/plutoprint/plutobook/archive/refs/tags/v0.14.0.tar.gz"
  sha256 "954c3c3fdd01d5eee69971645f35de9cbc1d6c6a859c9ce6dbea9668dfaa1ac7"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "afbd72a618ac5debc44e705cf9290a6712cdae7162e8246b69079c79795a60b8"
    sha256 cellar: :any, arm64_sequoia: "05716ac1207f7721b68321626c2e3c3ecdbfa130e987979f325bd7c4bc5dbcff"
    sha256 cellar: :any, arm64_sonoma:  "205d120812f6c1363dac6525e49dbb76f169322f927801b84b760e25881b03f8"
    sha256 cellar: :any, sonoma:        "fbebbe48ddf1c17c0da3c082844ea4ebe11b36407bce99456586e0787017b26b"
    sha256               arm64_linux:   "6a0dbdf4fc84e7709885b7c036c4389822b589f31976ede7d28d00b48d53ea65"
    sha256               x86_64_linux:  "7fb09fb9695f24af7fca25f38774d2c1dce4dc74bd401c450a1aeaf1fa1182dc"
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