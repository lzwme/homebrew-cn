class Opencode < Formula
  desc "AI coding agent, built for the terminal"
  homepage "https://opencode.ai"
  url "https://registry.npmjs.org/opencode-ai/-/opencode-ai-1.0.143.tgz"
  sha256 "013173a690c47b334faf876a5be222cdd0bb7818fed7512646f67da8d10d44cb"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "da761d820d31f79dca1499118cab0f5a7faa525e7dba73f5e6f1a5c83d17bb91"
    sha256                               arm64_sequoia: "da761d820d31f79dca1499118cab0f5a7faa525e7dba73f5e6f1a5c83d17bb91"
    sha256                               arm64_sonoma:  "da761d820d31f79dca1499118cab0f5a7faa525e7dba73f5e6f1a5c83d17bb91"
    sha256 cellar: :any_skip_relocation, sonoma:        "79250213416c9271ed1b23c8e8d85dbfea67b68313810f3a1ff6b2c72e2d097b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f6c5355327abbf558f48890fb1bb306bfe5ca13db8b2af52168da3cc37ad0ea7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e35ef175a4eaa3ad5f5063697093ee4d27f2e5ca4286d8c949d7ec9768d58f8e"
  end

  depends_on "node"
  depends_on "ripgrep"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/opencode-ai/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "opencode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opencode --version")
    assert_match "opencode", shell_output("#{bin}/opencode models")
  end
end