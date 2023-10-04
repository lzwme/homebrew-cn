class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://ghproxy.com/https://github.com/wofr06/lesspipe/archive/v2.09.tar.gz"
  sha256 "fe67ff374fde84c42a549e0e7c9b4c772dc68dd7e32aaa32672864dbd951664f"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3339cf21563f5d610d86230e311ed696b06924684310e0620cae20b2a1cd1451"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3339cf21563f5d610d86230e311ed696b06924684310e0620cae20b2a1cd1451"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3339cf21563f5d610d86230e311ed696b06924684310e0620cae20b2a1cd1451"
    sha256 cellar: :any_skip_relocation, sonoma:         "3339cf21563f5d610d86230e311ed696b06924684310e0620cae20b2a1cd1451"
    sha256 cellar: :any_skip_relocation, ventura:        "3339cf21563f5d610d86230e311ed696b06924684310e0620cae20b2a1cd1451"
    sha256 cellar: :any_skip_relocation, monterey:       "3339cf21563f5d610d86230e311ed696b06924684310e0620cae20b2a1cd1451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "959899f11f260332fb942b3220caacb20bfa7f1f71a469e4d30475c5a25f95e8"
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