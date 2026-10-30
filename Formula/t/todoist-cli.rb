class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.8.3.tgz"
  sha256 "1445e74f0a19d92f2ea5dfb67a4bdf1ffbdf3830a41f83ba4af1649b60a6f0a9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "de9f1f50f676e8e4f20bf270dceb52863e8e5cf91e68bfe7f0bc909a1fa5d3c3"
    sha256 cellar: :any,                 arm64_tahoe:       "de9f1f50f676e8e4f20bf270dceb52863e8e5cf91e68bfe7f0bc909a1fa5d3c3"
    sha256 cellar: :any,                 arm64_sequoia:     "de9f1f50f676e8e4f20bf270dceb52863e8e5cf91e68bfe7f0bc909a1fa5d3c3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e965ff0d383666498b3b499fec77fafa72c9bcd246437e2fd3e24f9f450b53a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "17d937ec6dff9e95a36a4fc880ae0dbc5ce4c182a1b92ee1381039e46ee8331f"
  end

  depends_on "rust" => :build
  depends_on "node"

  resource "keyring" do
    url "https://ghfast.top/https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.2.tar.gz"
    sha256 "b461a450df324a73219c6352186b95e4501b3f9099b876b023c9cdcf1d8cbf9d"

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