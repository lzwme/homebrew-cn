class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.1.2.tgz"
  sha256 "80de649136f5b5ccfe24b8c274bdcf2f1f9450263364b0487e112ca3a0459ecc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bfcf6540beefd9fcdaac436135429ce3b822eff42d678334210404779134dc3d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bbacf009be87e982950cbb7c1d36711ed06c8fae78b570751f4a6bc8fd3e28f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5d84150bb99bc7b3c694b6205c1c300a5056f3145a3932d356ac73778efff215"
    sha256 cellar: :any,                 arm64_linux:       "0997899c0260835b6c947919916820bdb7c38a816bb32501a32919e30d71972c"
    sha256 cellar: :any,                 x86_64_linux:      "9aa91e638a0d2732f4578f25674c27d4f0367e85d8683862e773c9e980e76b54"
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