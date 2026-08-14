class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.2.0.tgz"
  sha256 "0604ec5f00eee023f9821f372462f6ed76e39c6b9c8edb50661e7f61c4c9e6e3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d9ca44925279fab4451bc281b59d8ebb99cc2baa5f02db89d916906afc4aacbe"
    sha256 cellar: :any,                 arm64_sequoia: "87a97eb8cfbbfebee6cddae09425e1f269e6cb2be9e58a10deda5e2b02828a3e"
    sha256 cellar: :any,                 arm64_sonoma:  "67f93469cccfb0ef9679dba249d0ac76f24cc013d06b1244b0131950be8ad522"
    sha256 cellar: :any,                 sonoma:        "37842335f850935d6559cafe9182775932d7708884e6c5bd13b8808ff9d76e73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e54648304e5eec545ac431a53aca79540795583f22f45b8630fc7e17be92936b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1a5cb7c9617d0a457431322bca3eee3822f116652c027363cba8548588a2c35"
  end

  depends_on "node"

  on_macos do
    depends_on "cmake" => :build
    depends_on "rust" => :build
  end

  resource "rolldown" do
    url "https://ghfast.top/https://github.com/rolldown/rolldown/archive/refs/tags/v1.2.1.tar.gz"
    sha256 "05615e3dd0991fe24070626ed80e18bb95a253faa865d45e5b86e65057672d73"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/modelcontextprotocol/inspector/#{LATEST_VERSION}/package-lock.json"
      regex(/^v?(\d+(?:\.\d+)+)$/i)
      strategy :json do |json, regex|
        json.dig("packages", "node_modules/rolldown", "version")&.[](regex, 1)
      end
    end
  end

  resource "keyring" do
    url "https://ghfast.top/https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v1.3.0.tar.gz"
    sha256 "349be987e7582e6aa26763b2de96c4cbbd0d3cfba2417d9733524589fdbc275f"

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