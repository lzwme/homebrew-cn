class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.2.38.tgz"
  sha256 "54cbfde64e6b8e07f884329f54e29216b9313fc09a695bade34b744606444e41"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "95c605c571b4cc13c74020e347f7bb5f1a46cf1a98945c43debfff7bef2dfe08"
    sha256 cellar: :any,                 arm64_sequoia: "bd0821f437c2bd4fcfe354a5585a584aca1deca4d62c2ad274c3579869afc613"
    sha256 cellar: :any,                 arm64_sonoma:  "bd0821f437c2bd4fcfe354a5585a584aca1deca4d62c2ad274c3579869afc613"
    sha256 cellar: :any,                 sonoma:        "6fbc465e0a7496f349ef57d6b971bc2d49998ba720f59327079a647a61ecc11c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4f40f7fe847653e315afad7720f04fb6bb971b057167d619bd6458dc6f296783"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc390e01c5d7401bc454054ef29120b8c88ebb196a48c4d1a99472148aac93a9"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 5
    sleep 5 if OS.mac? && Hardware::CPU.intel?
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end