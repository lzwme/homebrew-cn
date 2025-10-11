class ChromeDevtoolsMcp < Formula
  desc "Chrome DevTools for coding agents"
  homepage "https://github.com/chromedevtools/chrome-devtools-mcp"
  url "https://registry.npmjs.org/chrome-devtools-mcp/-/chrome-devtools-mcp-0.8.0.tgz"
  sha256 "98a4fc3c43cc258401815e177e9945b6a8cb84618efa22426bbe2651fc3f5604"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "748d399672642f2449b155e2443026d78b140666d597faca9a22e6ed2e2637f6"
    sha256 cellar: :any,                 arm64_sequoia: "350d49e580ccb8c680192824520cc6a7b4ee4e87b606933349db38cb4fcb4c80"
    sha256 cellar: :any,                 arm64_sonoma:  "350d49e580ccb8c680192824520cc6a7b4ee4e87b606933349db38cb4fcb4c80"
    sha256 cellar: :any,                 sonoma:        "e98677b0fad4d77f58177f051d819c0c6b80f83090c28617564d06fb1d98f034"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3793859dbe993a7f35bc172036b48f45002de49dbebfd8c406bd5448005487a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "717f0baadb828494a6db1d308dd45c8ff3d21ad633010bd446e39587125f087a"
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