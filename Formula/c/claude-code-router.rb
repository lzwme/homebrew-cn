class ClaudeCodeRouter < Formula
  desc "Tool to route Claude Code requests to different models and customize any request"
  homepage "https://musistudio.github.io/claude-code-router/"
  url "https://registry.npmjs.org/@musistudio/claude-code-router/-/claude-code-router-3.0.2.tgz"
  sha256 "0e8f855a97ab150e3e6662ccd24cb197ca0075e390a998bc50de986a4c44f935"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "295d69f74689f8b4c225e920df8ad16f25afa121ad0bdfb93b81ecb9eadadd04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d920cef49d6bd55e682cb8edd264f9c3e31c1ad2f8f04c3b65229bd46f6a2b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "386d6cdf70a4de2e786e97c1b47b6840b6d6bf15dd42be5daeb33b2d5a1f1ffd"
    sha256 cellar: :any_skip_relocation, sonoma:        "22ad10cab817b1deb7f314cd800413ea25741bef4dd27e578d7ca473e2d4af8b"
    sha256 cellar: :any,                 arm64_linux:   "b097bfdef3d4a537d227a76cb9702f9a86d61fcb9b15790e8db95195df07d399"
    sha256 cellar: :any,                 x86_64_linux:  "0c108b59d6a25eaac6292a30aca7adfb2d915e65cc40995c91829879cf58f015"
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