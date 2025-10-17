class Libedit < Formula
  desc "BSD-style licensed readline alternative"
  homepage "https://thrysoee.dk/editline/"
  url "https://thrysoee.dk/editline/libedit-20251016-3.1.tar.gz"
  version "20251016-3.1"
  sha256 "21362b00653bbfc1c71f71a7578da66b5b5203559d43134d2dd7719e313ce041"
  license "BSD-3-Clause"

  livecheck do
    url :homepage
    regex(/href=.*?libedit[._-]v?(\d{4,}-\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b7908d3b0cb2d06c816ad380e8b968d9a733d8d2715d3efee37d30c84859b97f"
    sha256 cellar: :any,                 arm64_sequoia: "130c26a65749e81d3dc981db8886115e7203062b0fc4c44d23916c318294c67e"
    sha256 cellar: :any,                 arm64_sonoma:  "601a2ed57d0c8465f70e33c7b70f5955e836fe7f6beac6472fe74375b1a1c092"
    sha256 cellar: :any,                 sonoma:        "a974fd48c78b24aff3b5e1dd4abc5edc7976dbb7e8f8ad155c5ab396f0603e4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea2ad9305e5d9c9e0c78631c9673aa7f027afeee465e149ef988e9f750ede779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "72a509c156cd1752a7b4e5bfee1c1d63e491c166f8871879f93958df06ce3ae6"
  end

  keg_only :provided_by_macos

  uses_from_macos "ncurses"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <histedit.h>
      int main(int argc, char *argv[]) {
        EditLine *el = el_init(argv[0], stdin, stdout, stderr);
        return (el == NULL);
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-L#{lib}", "-ledit", "-I#{include}"
    system "./test"
  end
end