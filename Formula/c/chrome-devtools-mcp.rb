class ChromeDevtoolsMcp < Formula
  desc "Chrome DevTools for coding agents"
  homepage "https://github.com/chromedevtools/chrome-devtools-mcp"
  url "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-0.6.1.tgz"
  sha256 "d7c6f22309e436cd4c68b705f4d0b76504ab105739494042b77e4802c05629d7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "153f536754dd37067af06b0e1922d58bcc3a1173c44cb1f8043e05bda1aca454"
    sha256 cellar: :any,                 arm64_sequoia: "eab398675d3ecdceb1bd66c5d7463090587936702d4dfe09417607829818f28e"
    sha256 cellar: :any,                 arm64_sonoma:  "eab398675d3ecdceb1bd66c5d7463090587936702d4dfe09417607829818f28e"
    sha256 cellar: :any,                 sonoma:        "23a54b1045298b305d69f27b64a7776629625b74d89842c8e52ea6e634e0b504"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5cd02123949e51224c93fce1683af54d6c6e3b4039d784e19d2750282b307107"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b83eebee0f757abff2e12d63b03fe2337b2e64af6783460acd5739fe54f864"
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