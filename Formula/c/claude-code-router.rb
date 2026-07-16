class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.5.tgz"
  sha256 "0af6b61d7c443804039eb1323acd12cff750b8cb25c15dd979f3ccef0ea9a67d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "905a19d5bdc9d547302c7a6e0d5e98c601885d9d9a4376c8f3e30acafde69497"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc17e564bff186a34392d411651e21e7a1c93703e26d0bdfd22297679e9a7cff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e7989ca15339795a77a13512ffe6e4bad4ddf660232a4ab9997b26056238f613"
    sha256 cellar: :any_skip_relocation, sonoma:        "f1e0fcea8f2211bb276161d5a013a3550ed8d3e0cb0e23117b73944fa8adf4dc"
    sha256 cellar: :any,                 arm64_linux:   "5ddef204a227c2603efff6980e70fc56c7b5ce6d7ee1aa06357ffeec9fe11636"
    sha256 cellar: :any,                 x86_64_linux:  "9f84016d419bce00461efd5f649e326e462e0f71de7e7e7faa6cbd02590685bf"
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