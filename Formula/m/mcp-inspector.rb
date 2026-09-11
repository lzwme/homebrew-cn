class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.6.0.tgz"
  sha256 "e9bde03c45b62453d3b320b1dc2d2e8e997d172883b082b75deb938ef0c96a29"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2555882a6149230df840d594b904cb1a0fda536b6fb3e71e985097a056e8ef2c"
    sha256 cellar: :any,                 arm64_sequoia: "5371383deb90f485fb8c9381a898d7775b0878f218ebf8cf45897e2a3faf1cd8"
    sha256 cellar: :any,                 arm64_sonoma:  "283fd953b111154709879074da9f4021e35e51c947be4e9686cc1f3ffe521a7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "06e39d0d7c1a9b8276cbdc184f3022446e0b2137ce626da40faa93ef85992cb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7ff6d1498b4ae0e45b00183485d00e858430af233104b48abe3bddbaeeda8af"
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