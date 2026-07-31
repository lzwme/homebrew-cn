class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.0.0.tgz"
  sha256 "10583f3dd01cfe4e050b2581e50902adae33fe6bec32074182cb47287799d9d3"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0d419743cb0b1b43c5832dcf1279593ae107a659199c4d37f959a421e12d0439"
    sha256 cellar: :any,                 arm64_sequoia: "75b8851d406f18f2758f0837a4bb27a5114b87b799ef2deaab1549d3a8d13523"
    sha256 cellar: :any,                 arm64_sonoma:  "7734b11f1df9c124955467e7a014781cf52eaaa165fd4157985babc980f7f2e1"
    sha256 cellar: :any,                 sonoma:        "27215a321031a4914fb13748284e2d6445ee64f2df572c0b4ae4a5b05582a4f2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b97140e3084eb27e963ca4cb70200286a7e4369eb458eadd10400ff9fbae2575"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3963392d6292193cfd90c2cc5ce0b214549d90446e5619d530fd008ea907455"
  end

  depends_on "node"

  on_macos do
    depends_on "cmake" => :build
    depends_on "rust" => :build
  end

  resource "rolldown" do
    url "https://ghfast.top/https://github.com/rolldown/rolldown/archive/refs/tags/v1.1.5.tar.gz"
    sha256 "2042204fda63956408dc102dd5cf5577368077ed70f9bce68474ed983c779879"

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