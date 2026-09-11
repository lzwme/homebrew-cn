class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.3.1.tgz"
  sha256 "16cb51c40be9a344026c058520007378a64da94e806d6c630355a993f7b99d4f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "219d6866112f7f6bd3d8e5c89b6af44c2cd9d0e9564f5108790632f62f512dd3"
    sha256 cellar: :any,                 arm64_tahoe:       "b9be6bfba79c6d1b87a44bdde588657b7ea0c0e5891b467bfda17955e533d984"
    sha256 cellar: :any,                 arm64_sequoia:     "645975de53a22acc9052d1c89214870e3ceb6f1a3086cb9edc96c13367cc72f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "43d012e78884a0e481c895f169fcaff5a1f648a64de4b36d17ce8096c7dae25c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bd2339f53cd787bf702b3a427742086009cc2227d6c6bf00474c5c755e69b8e4"
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