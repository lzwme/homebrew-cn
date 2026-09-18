class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.3.7.tgz"
  sha256 "ffa29660bba78502b2984008f9ee66ddf3f787d5436d75a86c5bddeeefac993f"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "d05f7b75f85f60e2e064f48b3464b1d5fc9f038f0791db17a777ee358657fa40"
    sha256 cellar: :any,                 arm64_tahoe:       "2954c0118f22476784c980dc64f9395bfdf76af6cf0a969b4ab34781a0c6b87c"
    sha256 cellar: :any,                 arm64_sequoia:     "df5ec50c6275720e743d052bd255e0c82f4b6ad7dca0a7694db9167c5c5cd814"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d6d9fd5ad53de8b42043ffb5078a25215c96c69a9bce2413075b1ba1426998e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "888790636ac712b31fec8bbf846d159b0369a5aa8898421b2670d2690bc42c73"
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