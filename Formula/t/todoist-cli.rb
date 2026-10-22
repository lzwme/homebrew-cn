class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.5.5.tgz"
  sha256 "114435ccb129bfc835f1de7c5f6f1b375a73c5140e75e94978b3a592791b5295"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "1f6b7c24c745d4b64b4e3d3435490e65a351fad4313bcd5dafdf6ee0c3f5e3b5"
    sha256 cellar: :any,                 arm64_tahoe:       "123519a43b770aa5b09d4ed419024b25786b81da4d88b7d53bb714e203275370"
    sha256 cellar: :any,                 arm64_sequoia:     "7b5511ffb328c200ea028551962418fd6591ad1b62109ee998ac7deb6b2d948e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5e9830abca5bca52f970aad2de738e7fcec7c73125420a540d081761b67303cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5e7e1911c933302a9ad10d969e4db5e1ad2afa67aea4b4502f4ac8edc37adb9e"
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