class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.6.tgz"
  sha256 "1fbb11b65ec4fb2d7d77b7313a4cdbeda288aa7839dcb72fe23f5eca5abbf66b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "383cc7590d5866ba056667f6195c785a4e031155ef148e697fef27f252f24e8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d72876fc0e2876d3fb5135ec8c3933825b7f7da52d1dbb2307345c7228f550bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a9fcca6eedde2d2435a5025abaaa0fc164fa370b21007e3915c817570feede5"
    sha256 cellar: :any_skip_relocation, sonoma:        "d57e43b4b290264a5183f271eb5bb9142c862dc4d39a3e5980d70ec401dcccc5"
    sha256 cellar: :any,                 arm64_linux:   "b190f6564ece137dd750af179231e186d37c28ad8df41426d3ead209b85113f0"
    sha256 cellar: :any,                 x86_64_linux:  "2e3ebf9548d1661b71e9e9f546b4aa65bd5d622a6efd77b7362d900da5216703"
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