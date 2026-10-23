class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.8.0.tgz"
  sha256 "979df61a13371da886e3432da5d34a048558b503ac54461e13eec509032943c2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "a98c0904c04bd78022b2a82fe275b29d3b8a24aa9958b0764b3c3b7796f23f40"
    sha256 cellar: :any,                 arm64_tahoe:       "88488b0cc0e81f3649c7e25a6664623020400174ad4b50893f32817d293ae15a"
    sha256 cellar: :any,                 arm64_sequoia:     "0f345d04e300f2a42756a598e5ff59b0def0dd49296e1ff6e228dc3343d33fb3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "bff267d80564928858d20ff4643b1bcb8cc2855e576774911da89a85bbdd0b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8326ee844045ee57a236298d6382f0f930c2833537a4b919b135d08fa2026a0d"
  end

  depends_on "rust" => :build
  depends_on "node"

  resource "keyring" do
    url "https://ghfast.top/https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.1.tar.gz"
    sha256 "b1f4847eb61306e8c4f1a0418bf9e47231e8fdbc41a88631777d5cfa515eaaaf"

    livecheck do
      url "https://ghfast.top/https://raw.githubusercontent.com/Doist/todoist-cli/v#{LATEST_VERSION}/package-lock.json"
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

    node_modules = libexec/"lib/node_modules/@doist/todoist-cli/node_modules"

    resource("keyring").stage do
      system "cargo", "build", "--lib", "--release"
      dylib = Pathname.pwd/"target/release/libnapi_keyring.dylib"
      node_modules.glob("@doist/cli-core/node_modules/@napi-rs/keyring-darwin-*/*.node").each do |prebuilt|
        cp dylib, prebuilt
      end
    end

    deuniversalize_machos node_modules/"app-path/main"
  end

  def caveats
    <<~EOS
      Looking for the third-party Go CLI previously published under this
      name (by sachaos)? It has been renamed. Install it with:
        brew install todoist-cli-go
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/td --version")
  end
end