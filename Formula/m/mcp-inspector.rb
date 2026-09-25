class McpInspector < Formula
  desc "Visual testing tool for MCP servers"
  homepage "https://modelcontextprotocol.io/docs/tools/inspector"
  url "https://registry.npmjs.org/@modelcontextprotocol/inspector/-/inspector-2.8.0.tgz"
  sha256 "4db39519d276b99fe650f1032a3256cb704648cc611e598a38e178b1ba8a7cbf"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "2b16179adfe7c7cfc4bc16ff91bdc80235b20a89303429ef55599226664f2aa4"
    sha256 cellar: :any,                 arm64_tahoe:       "00e76b1132dff6c4336a60deec37cac72ca4030da1115b7c7400121de67f4b95"
    sha256 cellar: :any,                 arm64_sequoia:     "d88d335f5574956179871054988543cf2a1b9b87f087c204d65da2701275a87c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a189359af93e6f3ee42b3fb153458fd117ce31e91cd59a7b2495946449c4f286"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "6ded978522542e423043902dc4f2bcec2a1f80b3f3dc7c93f9bf6170c31b1bea"
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