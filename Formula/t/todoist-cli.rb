class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.4.5.tgz"
  sha256 "dc51ee8379683494be0e74fb4ca48a187508e1b447478bc2ba04589e1f1e8d2e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "4d552fdb6bdc5ca5cc051073e1a2cf67c82ea9631cfd5d1cd123d12de590130a"
    sha256 cellar: :any,                 arm64_tahoe:       "693498da4339441c292d0e0eba60a88d20f9e4711ed1eceba1abe7ee6566c794"
    sha256 cellar: :any,                 arm64_sequoia:     "ec9e8a5a175f1c089389070aaf85cd94f7c7ee03d57d98d3e225e7dc5335478c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "af5d6850101507dd8b7f9c500938adef170a86e169fbbff19ce4e18a292e5812"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "b6dd64db715287bd08e370fda4cc158b9820bc2a2a981edf023663ee9208114f"
  end

  depends_on "rust" => :build
  depends_on "node"

  resource "keyring" do
    url "https://ghfast.top/https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.0.tar.gz"
    sha256 "dcb0381cf252c577ff5c0c3bb0d5dd0750fd04a528484e5dbfdfb3c1add12467"

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