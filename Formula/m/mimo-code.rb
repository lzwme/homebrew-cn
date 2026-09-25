class MimoCode < Formula
  desc "AI coding agent with cross-session memory"
  homepage "https://github.com/XiaomiMiMo/MiMo-Code"
  url "https://registry.npmjs.org/@mimo-ai/cli/-/cli-0.1.15.tgz"
  sha256 "ce31274755f7924573c733588d5485c582e6bd63f0313e63860b4e74c0924470"
  license "MIT"

  bottle do
    sha256                               arm64_golden_gate: "3ac4f6db31b64af97a0b86b47e4fb77dd2840ba6d963fdfa918e02766307360d"
    sha256                               arm64_tahoe:       "3ac4f6db31b64af97a0b86b47e4fb77dd2840ba6d963fdfa918e02766307360d"
    sha256                               arm64_sequoia:     "3ac4f6db31b64af97a0b86b47e4fb77dd2840ba6d963fdfa918e02766307360d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "1a29562555dc4a9caafbe524ae5ce424c03bd987eda8fc3e13f0e8bf1ab68b92"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f51ce0b2f58de8c1f9e1ff5a337820a93aeed3cded3b3888db6d467396f11b1e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args(ignore_scripts: false)
    bin.install_symlink libexec.glob("bin/*")

    # Remove binaries for other architectures, `-musl`, `-baseline`, and `-baseline-musl`
    arch = Hardware::CPU.arm? ? "arm64" : "x64"
    os = OS.linux? ? "linux" : "darwin"
    (libexec/"lib/node_modules/@mimo-ai/cli/node_modules").children.each do |d|
      next unless d.directory?

      rm_r d if d.basename.to_s != "mimocode-#{os}-#{arch}"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mimo --version")
    assert_match "mimo", shell_output("#{bin}/mimo models")
  end
end