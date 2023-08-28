class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://ghproxy.com/https://github.com/xwmx/nb/archive/refs/tags/7.5.8.tar.gz"
  sha256 "50118c348ab13d3f0bfe8e91edb12a2777b297023e67f2deab0338318f01afcb"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d7b7d7406400418f6a6b78a3991898c0b395c27141dd098af9016acef38983b8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7b7d7406400418f6a6b78a3991898c0b395c27141dd098af9016acef38983b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7b7d7406400418f6a6b78a3991898c0b395c27141dd098af9016acef38983b8"
    sha256 cellar: :any_skip_relocation, ventura:        "50d597dafb8ccb255ebda10021e1df9d9202d17a95a94c371ce9b94264ed364f"
    sha256 cellar: :any_skip_relocation, monterey:       "50d597dafb8ccb255ebda10021e1df9d9202d17a95a94c371ce9b94264ed364f"
    sha256 cellar: :any_skip_relocation, big_sur:        "50d597dafb8ccb255ebda10021e1df9d9202d17a95a94c371ce9b94264ed364f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7b7d7406400418f6a6b78a3991898c0b395c27141dd098af9016acef38983b8"
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