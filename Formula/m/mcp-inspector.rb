class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.12.0.tgz"
  sha256 "696004839ca25e3baa621c7c3ad6289be06d67df0039e374d80e19e93e5f3c23"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "244c33c5babe6472676e8845f64f26917d94037edeb6b88c8fe48f7ca806cc66"
    sha256 cellar: :any,                 arm64_tahoe:       "9b6a52fc97f423be92bdce5efd84047aaaaa0cb4fe1134e44007b590b1754e39"
    sha256 cellar: :any,                 arm64_sequoia:     "02d704b713b76121d5208e9a99417c0a429215e6ce57012eb31519d753bf07c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "913940dc5fb28d277ecf7fc0792d71cfeb00ade1fba157e94f7e8d11d87e4190"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "44c9bff061f933c6ed257afd873b6b6e2921f05a99df3e18821b5e1cd6aed2fb"
  end

  depends_on "node"

  on_macos do
    depends_on "cmake" => :build
    depends_on "rust" => :build
  end

  resource "rolldown" do
    url "https://ghfast.top/https://github.com/rolldown/rolldown/archive/refs/tags/v1.2.13.tar.gz"
    sha256 "f22d36d1dc3fc068274149b5e699058657a3f7da1802aee42e7e667f3a31cf04"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/modelcontextprotocol/inspector/#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/rolldown", "version")&.[](regex, 1)
      end
    end
  end

  resource "keyring" do
    url "https://ghfast.top/https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.1.tar.gz"
    sha256 "b1f4847eb61306e8c4f1a0418bf9e47231e8fdbc41a88631777d5cfa515eaaaf"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/modelcontextprotocol/inspector/#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/@napi-rs/keyring", "version")&.[](regex, 1)
      end
    end
  end

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    node_modules = libexec/"lib/node_modules/@modelcontextprotocol/inspector/node_modules"
    resource("rolldown").stage do
      system "cargo", "build", "--lib", "--release", "--locked", "--package", "rolldown_binding"
      dylib = Pathname.pwd/"target/release/librolldown_binding.dylib"
      node_modules.glob("@rolldown/binding-darwin-*/*.node").each { |prebuilt| cp dylib, prebuilt }
    end

    resource("keyring").stage do
      system "cargo", "build", "--lib", "--release"
      dylib = Pathname.pwd/"target/release/libnapi_keyring.dylib"
      node_modules.glob("@napi-rs/keyring-darwin-*/*.node").each { |prebuilt| cp dylib, prebuilt }
    end

    deuniversalize_machos node_modules/"fsevents/fsevents.node"
  end

  test do
    port = free_port
    ENV["CLIENT_PORT"] = port.to_s

    read, write = IO.pipe
    fork do
      exec bin/"mcp-inspector", out: write
    end
    sleep 3

    assert_match "Starting MCP inspector...", read.gets
  end
end