class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://ghproxy.com/https://github.com/xwmx/nb/archive/refs/tags/7.5.3.tar.gz"
  sha256 "062a50d8e8c77e8fdd52fb16a3744f556a56136e9939b43a6adc8b8fa8e1121b"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c12d3be461ead541c5d7fb8ae5fce04e3e1493be7de197d5deb9681cbbf434e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c12d3be461ead541c5d7fb8ae5fce04e3e1493be7de197d5deb9681cbbf434e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c12d3be461ead541c5d7fb8ae5fce04e3e1493be7de197d5deb9681cbbf434e2"
    sha256 cellar: :any_skip_relocation, ventura:        "5ca0bb3cc043341035bdb433072b8b2a9b35e2978b75ea9cff160119875cd71e"
    sha256 cellar: :any_skip_relocation, monterey:       "5ca0bb3cc043341035bdb433072b8b2a9b35e2978b75ea9cff160119875cd71e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ca0bb3cc043341035bdb433072b8b2a9b35e2978b75ea9cff160119875cd71e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c12d3be461ead541c5d7fb8ae5fce04e3e1493be7de197d5deb9681cbbf434e2"
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