class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.4.10.tgz"
  sha256 "d85922c5fe639a997a996289f0cd4717f49504718350bfa236458952c1a704f9"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "c9b50293051066af4c7813e968d2fa64b534f066a9b1c0f1dee6eed515f43856"
    sha256 cellar: :any,                 arm64_tahoe:       "3b7751f181690dee1f636ed12a399e20d2cbd8835281a9e5c7ddb13af48465bd"
    sha256 cellar: :any,                 arm64_sequoia:     "fbb17ba7fae4e0ab6cec96f96e945d8c45b8a30ee6b193147edff0aba4680345"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "db982a112a4a949dc04232aa746cc7fd5db3bee918719b1a5e1b00de24714f6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3590364cf6adae2dcbcbcb3ec1371a30002b05cdddc94e0018cb72e5864b4cb0"
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