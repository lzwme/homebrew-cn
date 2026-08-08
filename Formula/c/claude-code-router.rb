class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.19.tgz"
  sha256 "cdfd285febc01784b5888d00a612c5a69ec0666e9973e40b8e789f719bc4a186"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7ddffe9345b4c521e8c67eba9c8e3b00d8f48acd3574fc3ccbbb8fb105bea3f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4edf99dbf22866f90c2cc376c72067fedf714b8c6a83f9a31a40681cda92e7cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "74edc291677f7697c9a109774716be6cc2b491953cf4496049ec8917a6ed0a37"
    sha256 cellar: :any_skip_relocation, sonoma:        "65e4259bb7198abaac0ce4c90d860477eba2517c59314cf883f247fe80cd21a8"
    sha256 cellar: :any,                 arm64_linux:   "5f424daa9441c99ebbd9ead728d13058abd09bad62cdbcf29213a9db3b6ae6c6"
    sha256 cellar: :any,                 x86_64_linux:  "2daa9e36622ccfdc96dd1bc2573fc4b44911871edc496f79e2270d2fcec07e5c"
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