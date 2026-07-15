class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.4.tgz"
  sha256 "06c0878802dd58794b1c9a190a01a2ad979f0c3a67088d507a0c0fcdc76e711a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8ee33da7d6ce4d8167d8cd01a7e5c9eaf22cf16cf713ac9432787a5836dc473"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec592dc0c3def4219c219ee4b896a3ebf4b2cbde3cebaa01b95764f4216a328e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2e03908cbe5e15c779c56949d9d4f412a93a758cc0ddd85519a27aad45540108"
    sha256 cellar: :any_skip_relocation, sonoma:        "f86364671a6e798a7ac946896c6f716700f001f55b38a77c2861eca4060829e9"
    sha256 cellar: :any,                 arm64_linux:   "12070748f2e2eb0b8accf65f712e5c8931f03cdd3e6301d63412c22f3fd79b63"
    sha256 cellar: :any,                 x86_64_linux:  "c1bec5b5c46a24728d4ebf813c20f461e57ddfe190d5ca66baac8aa9dd8d1df5"
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