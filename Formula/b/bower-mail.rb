class BowerMail < Formula
  desc "Curses terminal client for the Notmuch email system"
  homepage "https:github.comwangpbower"
  url "https:github.comwangpbowerarchiverefstags1.1.1.tar.gz"
  sha256 "4c041681332d355710aa2f2a935ea56fbb2ba8d614be81dee594c431a1d493d9"
  license "GPL-3.0-or-later"
  head "https:github.comwangpbower.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "317e78580fd4f956a1c6c525ce836dd8b8b6ff5af0864d0fb363402033a44438"
    sha256 cellar: :any,                 arm64_sonoma:  "7fd3cc425ab9943f8242d8d0930911d44ac5b900d1dbba9fd62d870152e9dba2"
    sha256 cellar: :any,                 arm64_ventura: "f5e51666cfa6098af4aadbeab01ec85237771a30aad6b8f2760cdabd862f93fd"
    sha256 cellar: :any,                 sonoma:        "ba197e4a9cf81240974e8d87f5e8a0f7be362c938acb6fd1b5e6bd4aa517558a"
    sha256 cellar: :any,                 ventura:       "23ff1bcc55c0e73f559a369162b07f78ffae940ad93a71200957bd7c8613e9c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecabaca1eccc9762c9a7fb2762120e567830e9362e304392add42c171dc9ae50"
  end

  depends_on "mercury" => :build
  depends_on "pandoc" => :build
  depends_on "gpgme"
  depends_on "ncurses"
  depends_on "notmuch"

  def install
    system "make"
    system "make", "man"
    bin.install "bower"
    man1.install "bower.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}bower --version")

    assert_match "Error: could not locate database", shell_output(bin"bower 2>&1", 1)
  end
end