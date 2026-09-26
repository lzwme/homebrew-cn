class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.4.2.tgz"
  sha256 "cb8379855e0513ec8a0e184492a490da88bb2e963830865708ca05caec1c0509"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "d497602e78d171b8be2d28d4b232388fa5231216a24bdd4bfe57235bb67fa883"
    sha256 cellar: :any,                 arm64_tahoe:       "799f41e435bcc6b491401ea968cd9d3c64f651d356a20123f15cd8e69ddc9eb1"
    sha256 cellar: :any,                 arm64_sequoia:     "aa745298f5115e69bcdd83ebae90c85cfe44a36c189c9e996f6eea16b6e68bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7b7c9ec94a6a7739545291ec5d59a5ca205ca37785591f48419b743e39046098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "cb2c4b6a5d1c8ba1b4553fe6723de85a7b2f35866f2aa82291ab7d5075738681"
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