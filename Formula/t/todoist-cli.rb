class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.3.2.tgz"
  sha256 "8f62b535597e6b2c8769f14d03acff2ca54b745e28c538ae710c1bf164ba6c8d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "ce1e2feb4a421db7232c00e6b7146722ecbd11b286b45d3ce7408626bfb74563"
    sha256 cellar: :any,                 arm64_tahoe:       "e06e6c68866a019c10117354aaef551e7cb3d29c5e382b597d769658b09ff536"
    sha256 cellar: :any,                 arm64_sequoia:     "bd3535ef12bf303455d75e95fedb865e84fcbd9cccfe8b74a0b228c305ceaee7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c1f85e8159c6d1ab05e856ec0ad934f43e5ae3033761fabe31a9effc0261a12e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d90822f7bd3dd965619e03f0a66a34162abdb14aabb0bf5699374a6faaf425ad"
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