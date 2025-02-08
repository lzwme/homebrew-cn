class Ne < Formula
  desc "Text editor based on the POSIX standard"
  homepage "https:github.comvignane"
  url "https:github.comvignanearchiverefstags3.3.4.tar.gz"
  sha256 "6958b5cd051d85dcdebbf45aeed2af077346a58d1d18ad14e1db477ce5519d29"
  license "GPL-3.0-only"
  head "https:github.comvignane.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "0c706c6b164b969590e18e216749428499344301311d38019f7e6e68165d3467"
    sha256 arm64_sonoma:  "507d64103eaa17b9b593406d7727a8f94919e7b14a06ed35d9f6c85a8138b47e"
    sha256 arm64_ventura: "c59bbbd54eab62c73c3f51c15022fbd5c68b35bb8f917030ed8006cb990486d3"
    sha256 sonoma:        "3045ec9a5ff38c4cabefdac8aa0696b311765d09649d47fae57951c8915b9afe"
    sha256 ventura:       "989c1e6af26b0106dce329c440299b58676f7bccd200ed218be8aa65256281f9"
    sha256 x86_64_linux:  "17fc5f7fc5234146da65cbb6a18ba1643bdd009ed76822c7cb2efb3837a05631"
  end

  depends_on "texinfo" => :build

  uses_from_macos "ncurses"

  on_linux do
    # The version of `env` in CI is too old, so we need to use brewed coreutils.
    depends_on "coreutils" => :build
  end

  def install
    # Use newer env on Linux that supports -S option.
    unless OS.mac?
      inreplace "version.pl",
                "usrbinenv",
                Formula["coreutils"].libexec"gnubinenv"
    end
    ENV.deparallelize
    cd "src" do
      system "make"
    end
    system "make", "build", "PREFIX=#{prefix}", "install"
  end

  test do
    require "pty"

    ENV["TERM"] = "xterm"
    document = testpath"test.txt"
    macros = testpath"macros"
    document.write <<~EOS
      This is a test document.
    EOS
    macros.write <<~EOS
      GotoLine 2
      InsertString line 2
      InsertLine
      Exit
    EOS
    PTY.spawn(bin"ne", "--macro", macros, document) do |_r, _w, pid|
      sleep 1
      Process.kill "KILL", pid
    end
    assert_equal <<~EOS, document.read
      This is a test document.
      line 2
    EOS
  end
end