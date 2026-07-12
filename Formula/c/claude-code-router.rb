class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.3.tgz"
  sha256 "e157d16f23e529d1408cba41e2720ff45dccaa5fc525e95f9b17df73a4f57948"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "305dda240346df4381faec4de6e991880d57f999e958de4d9e8fdc445687a1cb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "85163e2932868685f97b2792313d2a24485636ca9622facb83b1768713cd853f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3ec888a86f598a51267906b22ac5c8cb19023d1e26bd1117a3bd2b94e0fd569"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f8078b76cffe6a3461c6a9eb8667c5180b6870e811e4ddf635bb42f25ee11c7"
    sha256 cellar: :any,                 arm64_linux:   "273394a254b16f788c4822781628986fefd3d7e2a4942f6abd5fd85738764dd5"
    sha256 cellar: :any,                 x86_64_linux:  "0a90be48a06da0baa4fecfffda3647265027e97cd97442ee0f538d65eab5b9f9"
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