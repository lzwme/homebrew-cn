class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://ghproxy.com/https://github.com/xwmx/nb/archive/refs/tags/7.5.0.tar.gz"
  sha256 "15ebd54a0a18f810af519eeb29c11f332884ef33fa4b6218323f6cd5e83c5980"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51e3041e0bf3a33203f47312fdb9dc1729891d78f093739fea98ffa1b46afe89"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51e3041e0bf3a33203f47312fdb9dc1729891d78f093739fea98ffa1b46afe89"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51e3041e0bf3a33203f47312fdb9dc1729891d78f093739fea98ffa1b46afe89"
    sha256 cellar: :any_skip_relocation, ventura:        "436d99daadf2edd5a76e8dc897cbf404c8a45cfb915f913cde646289ffb3e1f0"
    sha256 cellar: :any_skip_relocation, monterey:       "436d99daadf2edd5a76e8dc897cbf404c8a45cfb915f913cde646289ffb3e1f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "436d99daadf2edd5a76e8dc897cbf404c8a45cfb915f913cde646289ffb3e1f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51e3041e0bf3a33203f47312fdb9dc1729891d78f093739fea98ffa1b46afe89"
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