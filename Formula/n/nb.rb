class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://ghproxy.com/https://github.com/xwmx/nb/archive/refs/tags/7.6.0.tar.gz"
  sha256 "9f51e214f93aadf5ba075cf4fc377f1342ce48d5137e9eff153be02e47f0cc72"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d41bdfd1e1983568de112008e8777d87db2b40b8ffe70cb5d4afa3ba1b7416cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d41bdfd1e1983568de112008e8777d87db2b40b8ffe70cb5d4afa3ba1b7416cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d41bdfd1e1983568de112008e8777d87db2b40b8ffe70cb5d4afa3ba1b7416cb"
    sha256 cellar: :any_skip_relocation, ventura:        "8c3a9efaf5927d2f63d58a7171734c43e94d6ceadd9c9d57a1ca71f5bb4ee667"
    sha256 cellar: :any_skip_relocation, monterey:       "8c3a9efaf5927d2f63d58a7171734c43e94d6ceadd9c9d57a1ca71f5bb4ee667"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c3a9efaf5927d2f63d58a7171734c43e94d6ceadd9c9d57a1ca71f5bb4ee667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d41bdfd1e1983568de112008e8777d87db2b40b8ffe70cb5d4afa3ba1b7416cb"
  end

  depends_on "bat"
  depends_on "nmap"
  depends_on "pandoc"
  depends_on "ripgrep"
  depends_on "tig"
  depends_on "w3m"

  uses_from_macos "bash"

  def install
    bin.install "nb", "bin/bookmark"

    bash_completion.install "etc/nb-completion.bash" => "nb.bash"
    zsh_completion.install "etc/nb-completion.zsh" => "_nb"
    fish_completion.install "etc/nb-completion.fish" => "nb.fish"
  end

  test do
    # EDITOR must be set to a non-empty value for ubuntu-latest to pass tests!
    ENV["EDITOR"] = "placeholder"

    assert_match version.to_s, shell_output("#{bin}/nb version")

    system "yes | #{bin}/nb notebooks init"
    system bin/"nb", "add", "test", "note"
    assert_match "test note", shell_output("#{bin}/nb ls")
    assert_match "test note", shell_output("#{bin}/nb show 1")
    assert_match "1", shell_output("#{bin}/nb search test")
  end
end