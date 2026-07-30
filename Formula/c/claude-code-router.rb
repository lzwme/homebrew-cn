class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.17.tgz"
  sha256 "0575f11ad5fe62164143e7f4bae7afdf73c2f641f81e9bd718e56b30a8a04cb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7912df2d6337fc4add9cffb8c28672d8470fe4c140f8c283aaca6186901b9b2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c7411060653bc833b29c91354392aa923adf4a87d0e5ee4921f88c25ffb2c7ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abe4f55ee074c806234520e7f9260454ef6ee531cc043dd0a9acff874a277df8"
    sha256 cellar: :any_skip_relocation, sonoma:        "d35f956d32aee713efc4be46e3b1d61bcc02ad074d1cde17fe7ab2f0ebb9f5a2"
    sha256 cellar: :any,                 arm64_linux:   "16851dbaaa1f0dd33503e3084ffad7de15b3351eb98251de29452c75fddd6626"
    sha256 cellar: :any,                 x86_64_linux:  "b3a9ef42b8fb4afd3dea071558af4a79e70dcc355271345fe7e96fc758561e5c"
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