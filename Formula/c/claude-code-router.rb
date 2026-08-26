class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.22.tgz"
  sha256 "a6de50b2e69a8510159c31f903af495850220b1d61f67b409ef0f3a6e4eb3a48"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3216875fdc215dd68ea999f42fd8abb51090d221807e5244287e1710457b3975"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc60c1997e9c8b991dd15573a294f092176cc884d37025329d950a69067c3e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2480cdc9a3d04706ddc4b8a7a62faeff2f86dced4387c08321b05b457fa5646"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef323450c0ae0a44871d10afb50dbc70fbc1d92664990398c15e0a28c75b6ddc"
    sha256 cellar: :any,                 arm64_linux:   "706f4f4e39e35db0db39dfde256face7d6bea026a7f3a7784daa189ff3452e32"
    sha256 cellar: :any,                 x86_64_linux:  "d930a0177c873983e21bb9087024d5e54441f3af069ec185bfcd73c80c9ad2f3"
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