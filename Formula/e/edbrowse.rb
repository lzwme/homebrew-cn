class Edbrowse < Formula
  desc "Command-line editor and web browser"
  homepage "https://edbrowse.org"
  url "https://ghfast.top/https://github.com/edbrowse/edbrowse/archive/refs/tags/v3.8.13.tar.gz"
  sha256 "599fdbc0ee6f500cc63af91c88404d90e79cbfb175c62b774c8d4d458b663877"
  license "GPL-2.0-or-later"
  head "https://github.com/edbrowse/edbrowse.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0dedb75ee8b54aa73a84fd5c77d54834ecdb8dfc7a4d500403e4bc8ff94d2215"
    sha256 cellar: :any,                 arm64_sequoia: "dc8b4ff71bf2852f4d63965ea8c008d011a863372e444ba60a05d7b1e7b11ace"
    sha256 cellar: :any,                 arm64_sonoma:  "b02674f2ad438baa433e9a5d52bd712aef3aead4ba2935da0874009cf86730b9"
    sha256 cellar: :any,                 sonoma:        "4ef780e3da75330f0b99d487f16ec26396bacbf8687a29d3ef1f239e5ceed9a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "643ed22e352b0a7801507fd550abf2e5ae5d75ceb4393c76e13deae761a361a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "763e41666cf0852f0b0868fd43b5006b5bcb6bdad86edce8e90d3687d506444e"
  end

  depends_on "pkgconf" => :build
  depends_on "quickjs" => :build
  depends_on "curl"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "readline"
  depends_on "unixodbc"

  def install
    cd "src" do
      make_args = [
        "QUICKJS_INCLUDE=#{Formula["quickjs"].opt_include}/quickjs",
        "QUICKJS_LIB=#{Formula["quickjs"].opt_lib}/quickjs",
      ]

      system "make", *make_args
      system "make", "install", "PREFIX=#{prefix}"
    end
  end

  test do
    (testpath/".ebrc").write("")
    (testpath/"test.txt").write("Hello from ed\n")

    system "printf %s\\\\n 's/ed/edbrowse/' 'w' 'q' | #{bin}/edbrowse -c .ebrc test.txt"
    assert_equal "Hello from edbrowse", (testpath/"test.txt").read.chomp
  end
end