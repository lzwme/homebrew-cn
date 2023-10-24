class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://ghproxy.com/https://github.com/wofr06/lesspipe/archive/refs/tags/v2.10.tar.gz"
  sha256 "ad1589592ff46f7738eb1ba2ecc911b003a6afe9376656e9f6ec920d354a58df"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2ea6587cc89eacae552c8af912852ac059d2cbada2c8727c019fcd500d5803c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ea6587cc89eacae552c8af912852ac059d2cbada2c8727c019fcd500d5803c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2ea6587cc89eacae552c8af912852ac059d2cbada2c8727c019fcd500d5803c0"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ea6587cc89eacae552c8af912852ac059d2cbada2c8727c019fcd500d5803c0"
    sha256 cellar: :any_skip_relocation, ventura:        "2ea6587cc89eacae552c8af912852ac059d2cbada2c8727c019fcd500d5803c0"
    sha256 cellar: :any_skip_relocation, monterey:       "2ea6587cc89eacae552c8af912852ac059d2cbada2c8727c019fcd500d5803c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaa424099a56c5a8dfd5e48cbe56bb773425b965d5384fef92d40645a69dc293"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      add the following to your shell profile e.g. ~/.profile or ~/.zshrc:
        export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s"
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath/"homebrew.tar.gz", :exist?
    assert_match "file2.txt", pipe_output(bin/"archive_color", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end