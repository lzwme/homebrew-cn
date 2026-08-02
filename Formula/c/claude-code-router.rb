class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.18.tgz"
  sha256 "681f0bd51dd7d8aa590186969d4c9b47aa837f0ebf4aea60cedb39c1d6024ecf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e3eda5e06518394146d64a6631ec4c2d5fa1341f3266ba59f62f5b45c4f9cab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc60b361f561e88fad99dbd89845b121f658e7fe340b58633d9b012ef2708358"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41db6354d65512716bd9b85d4f1d9d525f0c04288fb2edf8add93419c0c25e0a"
    sha256 cellar: :any_skip_relocation, sonoma:        "695858d4f9cd3440657914adf93f882dc3d6ce0f375701a0c2ab93080051f739"
    sha256 cellar: :any,                 arm64_linux:   "0a18aafb996111830b5a0694b7b1b7471b75075470b9e7a789b933c2018d8232"
    sha256 cellar: :any,                 x86_64_linux:  "bc8c64f5a84b90e88263d2c8e3c4137f7965ba44d22a439d0a74cd5d7a39cf16"
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