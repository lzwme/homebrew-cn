class Plutobook < Formula
  desc "Paged HTML Rendering Library"
  homepage "https://github.com/plutoprint/plutobook"
  url "https://ghfast.top/https://github.com/plutoprint/plutobook/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "466f45581e9e274beede8a78f64ace3b3ad94d813d6c7b1a05594ab7e7f7fa84"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c7390d2849056ee08dab603fa43945091310132b2b99ea6e57d4040d52ceafb5"
    sha256 cellar: :any, arm64_sequoia: "7b75a33d3e67202b7e8526cbc6af6f7e2fc1aa9a6b60e044261a46adfb97baa5"
    sha256 cellar: :any, arm64_sonoma:  "1ac4e37a9d176bba81b31dfc00613e1824a63d85ece7cc09d2248efd08e7bf88"
    sha256 cellar: :any, sonoma:        "d3a170bf61f6c6c79ec2b323451fc51c6d3c4a662f5a8c5b2de7fb4211e8c916"
    sha256               arm64_linux:   "c3dd56c8951641aa37089de303e8590a273ef12cd0bd1e7500bad718831978dd"
    sha256               x86_64_linux:  "dd7b003a54767b0fb1b34fe83948e77f6575479063d2e9cab61ccb40a1b129aa"
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