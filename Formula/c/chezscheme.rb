class Chezscheme < Formula
  desc "Implementation of the Chez Scheme language"
  homepage "https:cisco.github.ioChezScheme"
  url "https:github.comciscoChezSchemereleasesdownloadv10.1.0csv10.1.0.tar.gz"
  sha256 "9181a6c8c4ab5e5d32d879ff159d335a50d4f8b388611ae22a263e932c35398b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51cde006c2b97bf84caa052a6d07765e33fbdae21b66cd6c0cdb5bfda267ee9b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9c39185c83b72bba802036044c986372283a5f489a0d6119d467b25418d00ba1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21913a213c56d08efe39b91f80a478f7b3351db7e69a73e1bfd51bf621d55b1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a9eeb709f6a99fd0e9e314ecf500feeccc7cf10de3dcf279ed95cce56344268"
    sha256 cellar: :any_skip_relocation, ventura:       "bfa3d61ad2c6f134940cbd64ea1a1477caac43441f8a28d353b64a87171a9cbc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "15692ac0523606c7854c114af8d735b2bca2bfe9c434a78585bd2ae091053612"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e94bab3cb93b135cfdd00ddf2d43e9b8a0b9d15f248aa05bda1682c8dcc1a8d"
  end

  depends_on "libx11" => :build
  depends_on "xterm" => :build
  uses_from_macos "ncurses"

  def install
    inreplace "cversion.h", "usrX11R6", Formula["libx11"].opt_prefix
    inreplace "cexpeditor.c", "usrX11binresize", Formula["xterm"].opt_bin"resize"

    system ".configure",
              "--installprefix=#{prefix}",
              "--threads",
              "--installschemename=chez"
    system "make"
    system "make", "install"
  end

  test do
    (testpath"hello.ss").write <<~SCHEME
      (display "Hello, World!") (newline)
    SCHEME

    expected = <<~EOS
      Hello, World!
    EOS

    assert_equal expected, shell_output("#{bin}chez --script hello.ss")
  end
end