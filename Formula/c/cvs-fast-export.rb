class CvsFastExport < Formula
  desc "Export an RCS or CVS history as a fast-import stream"
  homepage "http://www.catb.org/~esr/cvs-fast-export/"
  url "http://www.catb.org/~esr/cvs-fast-export/cvs-fast-export-1.62.tar.gz"
  sha256 "8b1d1f836c27db24adae0121031b125ef2eef82eec6f6579a325427e101efd1f"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?cvs-fast-export[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5878b8e4ad1c779bfaaa3fc7a77597db02acde68436d3931c74124430b38e979"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88004f54a3f3c65fa80ef240788a7be11a95260e48de47c92b11e7f67b729f5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b909d52b327d65cd36754c85e22ae9f259581b9bc0f9992bf81924bd82f458b"
    sha256 cellar: :any_skip_relocation, sonoma:         "61c3b9cd2c7f64920e2e087af711cd2cf4393eab006c3e8189ee4b14fe2980d0"
    sha256 cellar: :any_skip_relocation, ventura:        "97252dabe4ecd589ccb1201058eefbd04bc1441d759ed1654c77d442412f2574"
    sha256 cellar: :any_skip_relocation, monterey:       "4f0988eac260e4813e2a2a154dac77a0d6bca74ec0d7d2b376d10972d10fdd8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bb4c2d9fc162b97638de3b59f97547f679443caca91728d01a3ca9224f1508a"
  end

  head do
    url "https://gitlab.com/esr/cvs-fast-export.git", branch: "master"
    depends_on "bison" => :build
  end

  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "cvs" => :test

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    cvsroot = testpath/"cvsroot"
    cvsroot.mkpath
    system "cvs", "-d", cvsroot, "init"

    test_content = "John Barleycorn"

    mkdir "cvsexample" do
      (testpath/"cvsexample/testfile").write(test_content)
      ENV["CVSROOT"] = cvsroot
      system "cvs", "import", "-m", "example import", "cvsexample", "homebrew", "start"
    end

    assert_match test_content, shell_output("find #{testpath}/cvsroot | #{bin}/cvs-fast-export")
  end
end