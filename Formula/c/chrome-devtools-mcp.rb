class ChromeDevtoolsMcp < Formula
  desc "Chrome DevTools for coding agents"
  homepage "https://github.com/chromedevtools/chrome-devtools-mcp"
  url "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-0.8.1.tgz"
  sha256 "14628110ac79e3f6c2ffeac19189184f74ee34f0da84d66eb260e151ff9a3357"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e14178e2cfa251d97a090496d9c5154d3ad2e3afea329123a7d3b42765cdf87"
    sha256 cellar: :any,                 arm64_sequoia: "7bbd4f608cddf0089e79331e2142b33904fc3f595d744c91bd88379c077d1c92"
    sha256 cellar: :any,                 arm64_sonoma:  "7bbd4f608cddf0089e79331e2142b33904fc3f595d744c91bd88379c077d1c92"
    sha256 cellar: :any,                 sonoma:        "b8934c1bad0a84bf8f937dab8d35a32c8eb34c3407cada08fe3f9abf0e97b34c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c94a2a747e58aaf2d49dceb68a727524c9343722158a4130b93dededbb7f860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "298ac18dc507489802267759d994f33377a07c0472a50b007fe77cd3c0eb5b54"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]

    node_modules = libexec/"lib/node_modules/chrome-devtools-mcp/node_modules"

    # Remove incompatible pre-built `bare-fs`/`bare-os`/`bare-url` binaries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules.glob("{bare-fs,bare-os,bare-url}/prebuilds/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chrome-devtools-mcp --version")

    json = <<~JSON
      {"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":"2025-03-26"}}
      {"jsonrpc":"2.0","id":2,"method":"tools/list"}
    JSON

    output = pipe_output(bin/"chrome-devtools-mcp", json, 0)
    assert_match "The CPU throttling rate representing the slowdown factor 1-20x", output
  end
end