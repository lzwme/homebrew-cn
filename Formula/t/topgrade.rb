class Topgrade < Formula
  desc "Upgrade all the things"
  homepage "https:github.comtopgrade-rstopgrade"
  url "https:github.comtopgrade-rstopgradearchiverefstagsv14.0.1.tar.gz"
  sha256 "e4262fae2c89efe889b5a3533dc25d35dd3fbaf373091170f20bcc852017e8be"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc5f13cd0c72e9b8da5f2c54d44928f27a0b3fb723f9f7ea40d10de7fd1d5a9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3465b89eaba5e0d58da089ad5a1269e155510fc39af4019879bb379a2701b936"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8843c568676924d9008c6db4ceca2065cc48d096418a3ef1b23e6f9f1c5b35e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d61e568422b51faa98295850c2a492968d5983b56f380d6b0149aff66abda68"
    sha256 cellar: :any_skip_relocation, ventura:        "82d399607a1c7b29c33ffc6ef02879de3ef68dfc1d30ac8618c4cc6d43ad992c"
    sha256 cellar: :any_skip_relocation, monterey:       "6153f2c6170194fc39f9d168c895c712a9ccf954f8e7c211d8397432b8efab3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a08906aaa40e5b3be25e7d66687407e099e90f3e2c587c023b408fdd5da3e74f"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["TOPGRADE_SKIP_BRKC_NOTIFY"] = "true"
    assert_match version.to_s, shell_output("#{bin}topgrade --version")

    output = shell_output("#{bin}topgrade -n --only brew_formula")
    assert_match %r{Dry running: (?:#{HOMEBREW_PREFIX}bin)?brew upgrade}o, output
    refute_match(\sSelf update\s, output)
  end
end