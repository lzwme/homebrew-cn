class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://ghproxy.com/https://github.com/xwmx/nb/archive/refs/tags/7.5.6.tar.gz"
  sha256 "4b176313fbd68f5675a528947f22adb57e2155741fbb2bcf89d9b2d93eedc739"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd8aefa75149caca71e775c64fb2a45322e1c6fd57ce09a108114fa38fbb5916"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd8aefa75149caca71e775c64fb2a45322e1c6fd57ce09a108114fa38fbb5916"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd8aefa75149caca71e775c64fb2a45322e1c6fd57ce09a108114fa38fbb5916"
    sha256 cellar: :any_skip_relocation, ventura:        "61497f1c097543bc55804c5f54fad80eaafd5c77290f10aedf0bec444b84c66c"
    sha256 cellar: :any_skip_relocation, monterey:       "61497f1c097543bc55804c5f54fad80eaafd5c77290f10aedf0bec444b84c66c"
    sha256 cellar: :any_skip_relocation, big_sur:        "61497f1c097543bc55804c5f54fad80eaafd5c77290f10aedf0bec444b84c66c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd8aefa75149caca71e775c64fb2a45322e1c6fd57ce09a108114fa38fbb5916"
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