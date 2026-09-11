class HfMcpServer < Formula
  desc "MCP Server for Hugging Face"
  homepage "https://github.com/evalstate/hf-mcp-server"
  url "https://registry.npmjs.org/@llmindset/hf-mcp-server/-/hf-mcp-server-0.4.18.tgz"
  sha256 "8cd7a1da6d6b77db7479c76996c311ea0593fecde0482fcf98fb4d762a3b22bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fabf18597875606f8c6d512fc9eea978aaf0cba9d3136e4ccd71462020e2834"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5fabf18597875606f8c6d512fc9eea978aaf0cba9d3136e4ccd71462020e2834"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5fabf18597875606f8c6d512fc9eea978aaf0cba9d3136e4ccd71462020e2834"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b794972e56f4464aadf41f7ddeac761a5059f015b5431536a3a18e50baead1ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b794972e56f4464aadf41f7ddeac761a5059f015b5431536a3a18e50baead1ce"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@llmindset/hf-mcp-server/node_modules"
    # Remove incompatible and unneeded Bun binaries.
    rm_r(node_modules.glob("@oven/bun-*"))
    # Remove dev-mode-only bundler and CSS-toolchain prebuilts.
    prebuilts = %w[
      @rollup/rollup
      @rolldown/binding
      @tailwindcss/oxide
      lightningcss
      vite/node_modules/lightningcss
    ]
    rm_r(node_modules.glob("{#{prebuilts.join(",")}}-*"))

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    ENV["TRANSPORT"] = "stdio"
    ENV["DEFAULT_HF_TOKEN"] = "hf_testtoken"

    output_log = testpath/"output.log"
    pid = spawn bin/"hf-mcp-server", [:out, :err] => output_log.to_s
    sleep 10
    assert_match "Failed to authenticate with Hugging Face API", output_log.read
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end