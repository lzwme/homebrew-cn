class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.2.2.tgz"
  sha256 "17782209f9c61dd0e7b5c8e60d20c470715a077b405020e1a80c8546781c32a5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f26c6a387625d7bff8e1a61bed0f7927290bb2781d587e6d813c4617c752d60b"
    sha256 cellar: :any,                 arm64_sequoia: "c9ea2206e8a1618c7ef2630e27d5c7c613f9318b019d9b97fc0f49ef16b27ed4"
    sha256 cellar: :any,                 arm64_sonoma:  "f71c5f48a55781e0224b97792f93d8014fe831d6c1960ac2760c10317652c610"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bb69180bb4eafbb82b23d79168f6205ca4e07aff51e6a5d07a891fa35d79c25a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "246a9e9096dca17bc889933ed50e44b26bf6996c5541fb8059b29ee4decf253c"
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