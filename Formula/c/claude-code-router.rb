class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.20.tgz"
  sha256 "00174e76c94c4386a752c9839dad0e217644d8497e32289cc32af0f2a4dd4ee4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f60ff98fd12bdc8791c281b6419f471da4a7428523e43cd01e4dbff266ce9052"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c55f1ce30097609f0f988def291c84b62ef102f9f3b879871463ab47ca8d8b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "550c62e6374af06cced5d6f957a1e088a547b255d11b7e851903d5876b1644b1"
    sha256 cellar: :any_skip_relocation, sonoma:        "03d2fb8d12ecd02658d4130b7b0e7913a34d929a48dfdf3901272f96e98234de"
    sha256 cellar: :any,                 arm64_linux:   "72a98687b41e0c29f70475fede9e120132c552c5d657f7b1b11904cafe9ff6e4"
    sha256 cellar: :any,                 x86_64_linux:  "064f2ca3131a737a4bb431d60a2b7bb89a279f1d8723cb6d12c5e815791022fa"
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