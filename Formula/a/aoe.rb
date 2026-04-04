class Aoe < Formula
  desc "Terminal session manager for AI coding agents"
  homepage "https://github.com/njbrake/agent-of-empires"
  url "https://ghfast.top/https://github.com/njbrake/agent-of-empires/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "83f2a6e2c91114f30d12e8f9d403b51b1f9afc69e7f1cf35068c4ee07a076234"
  license "MIT"
  head "https://github.com/njbrake/agent-of-empires.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b6a727a4b121effc323084ed6eaafbc78e790c1d2e82fd0f32e601a1c80e6f4"
    sha256 cellar: :any,                 arm64_sequoia: "f51e4938698bc9ae38f62f201584cecad0519a96f3dcee4d6805f8f33190108a"
    sha256 cellar: :any,                 arm64_sonoma:  "95d3e0918b6efdf84fc92ac53b431271c33161f9ecd387f6be8fb0022c5d47d5"
    sha256 cellar: :any,                 sonoma:        "be02b3afee902c8ebcb71b3a9e7d1aa359e9720fcef4ef2e17af2f710a7b1814"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc09f840bc25ad5e6df37cbada53250841dfb01298d0ac9e5375e8e85698c7d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a698bc98a798b5bd8178ad0e50e8146d94670beef7e5ebbef475169cd9e0fcf"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  depends_on "tmux"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"aoe", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aoe --version")

    system bin/"aoe", "init", testpath
    assert_match "Agent of Empires", (testpath/".agent-of-empires/config.toml").read

    output = shell_output("#{bin}/aoe init #{testpath} 2>&1", 1)
    assert_match "already exists", output

    status = JSON.parse(shell_output("#{bin}/aoe status --json"))
    assert_equal 0, status["total"]
  end
end