class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://ghproxy.com/https://github.com/xwmx/nb/archive/refs/tags/7.5.5.tar.gz"
  sha256 "c311be972e53de05574210d246c4366071d9fc642aa907f560ae0690dfbc051d"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e2408e3dd05497e291ac151ab513dd402e0521b0dacb9b9e44b922fafab721d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e2408e3dd05497e291ac151ab513dd402e0521b0dacb9b9e44b922fafab721d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e2408e3dd05497e291ac151ab513dd402e0521b0dacb9b9e44b922fafab721d"
    sha256 cellar: :any_skip_relocation, ventura:        "96bb20854e70ecbe9d1d7fd154b609dc38fd5f75eadabb23e3b8fff0aec0495c"
    sha256 cellar: :any_skip_relocation, monterey:       "96bb20854e70ecbe9d1d7fd154b609dc38fd5f75eadabb23e3b8fff0aec0495c"
    sha256 cellar: :any_skip_relocation, big_sur:        "96bb20854e70ecbe9d1d7fd154b609dc38fd5f75eadabb23e3b8fff0aec0495c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f003e193b3c294e0304cb5f02cda298ce9e2a2fe019e7bb602e4ec92bf2d83a"
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