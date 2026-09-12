class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.1.0.tgz"
  sha256 "f9bc4a77a56d1d9a951889a60096c75b2212cfe6328f762fce5a9c071be2175a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "158fa2c84ecb41c6a22fbbe608a91ba28d15a1ea78f4ac95311589831124059d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3f2efe1289ec72eb62ea8c34b2afa957b47f3ca4178391ef4806e625a1372450"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6f1d849ca3056b3f5b68b52db4e20b505a51950ac615e786a32260aa54d2886d"
    sha256 cellar: :any,                 arm64_linux:       "0add81b07a2e4ec26c990245197571b73c3b3a8a92b448e0838700fbe0b61461"
    sha256 cellar: :any,                 x86_64_linux:      "2c272eb4ebe7e6524f8fa0650fe5ff9216af7f5c4e89ae3320556552620fc436"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args

    # better-sqlite3's prebuilt binary is skipped by the sandbox, so build it via node-gyp.
    cd libexec/"lib/node_modules/@musistudio/claude-code-router/node_modules/better-sqlite3" do
      system "npm", "run", "build-release"
    end

    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/".claude-code-router/config.json").write <<~JSON
      {
        "Providers": [
          {
            "name": "test",
            "api_base_url": "https://api.test.local/v1/chat/completions",
            "api_key": "sk-test",
            "models": ["test-model"]
          }
        ],
        "Router": { "default": "test,test-model" }
      }
    JSON

    output_log = testpath/"output.log"
    spawn bin/"ccr", "start", "--port", free_port.to_s, "--no-gateway", [:out, :err] => output_log.to_s

    30.times do
      break if output_log.exist? && output_log.read.include?("CCR service started")

      sleep 1
    end

    assert_match "CCR service stopped", shell_output("#{bin}/ccr stop")
  end
end