class Nb < Formula
  desc "Command-line and local web note‑taking, bookmarking, and archiving"
  homepage "https://xwmx.github.io/nb"
  url "https://ghproxy.com/https://github.com/xwmx/nb/archive/refs/tags/7.5.4.tar.gz"
  sha256 "2b4f3378023200a5fbdc7c0e336405e8b63c1ca90964853dc5662c7914fa8618"
  license "AGPL-3.0-or-later"
  head "https://github.com/xwmx/nb.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7db81ff5d5af452c8ee80529dc2eab39fc197b89fe9bea9f5d25f76a6b4b5850"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7db81ff5d5af452c8ee80529dc2eab39fc197b89fe9bea9f5d25f76a6b4b5850"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7db81ff5d5af452c8ee80529dc2eab39fc197b89fe9bea9f5d25f76a6b4b5850"
    sha256 cellar: :any_skip_relocation, ventura:        "a9d53a29b95dc6a5ade455e5bd525a3145f1a380b61efd74db98700f0be61056"
    sha256 cellar: :any_skip_relocation, monterey:       "a9d53a29b95dc6a5ade455e5bd525a3145f1a380b61efd74db98700f0be61056"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9d53a29b95dc6a5ade455e5bd525a3145f1a380b61efd74db98700f0be61056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "887d03de4d37324dc55f34a503c67665a315af2de394733f922e79d24debd2cd"
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