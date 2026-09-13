class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.3.4.tgz"
  sha256 "60b6aa005f785d7c95799884ff10c53d9fe6083dee664639213da1dafacd48ec"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "3b0d1f94fc75ecc9c8792392f3e8a5d4079675d8c26d0b8126169c84d28cb303"
    sha256 cellar: :any,                 arm64_tahoe:       "6cc565f9d3023b67c242e6a52f0844482ff8cb8efd840c63b4287fff66d5ffb1"
    sha256 cellar: :any,                 arm64_sequoia:     "590af086412bd0a77a56da67a7f0c38ff015a77260ec4dd9f406f16bfe59995b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e9c9e6a83b4d40e38c65b00d0a71878b1d1b1a89eaef55cc44497847d65f97be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "363f44eaf03fb50d5c217549d63010310b77437134bfe0eb739a446923188473"
  end

  depends_on "rust" => :build
  depends_on "node"

  resource "keyring" do
    url "https://ghfast.top/https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.0.0.tar.gz"
    sha256 "0a3eb14fe07b733e945d25d1a5425021c728ed19886f426d22afa84fc97c7754"

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