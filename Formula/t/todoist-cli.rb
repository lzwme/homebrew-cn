class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.3.6.tgz"
  sha256 "249100e3033762bd157452feed30be2a0628b97b4ccc42099a7c84dd11ec0684"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "07eaefbd09f758cfed69d51cea40c0a27028d54bc93b1fbbebaa71343d02b809"
    sha256 cellar: :any,                 arm64_tahoe:       "e07c902d516fd641d61de55155d8ca5219aea30dfa62e90d1942ab0e54b9d64d"
    sha256 cellar: :any,                 arm64_sequoia:     "eff86400778d6fa365fc79b65c0cba28963f1bc427388ea072380d18348b949f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "13c5feb634e736d8f8aa8fa94a173aad22c2dfcb3a114404297db49d30b78a96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "973ce66ec20fcd1b79ef3117d345e9cb4d8879fbac36eabf801f2b155902e07f"
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