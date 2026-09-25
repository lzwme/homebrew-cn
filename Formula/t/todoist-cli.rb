class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.4.1.tgz"
  sha256 "3cb6e97de880b19a1dcf8b8ee3b973c58ecf2fcfd87f17e04c49a5c636b656f8"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "f7c4667f367bd01cd0e252e598122057fa362944a55637122bc417ee3f158238"
    sha256 cellar: :any,                 arm64_tahoe:       "4e2ff675d36e339ad1f647f0b40295b58d5b4b1eafa58d893cc76749f5de6a73"
    sha256 cellar: :any,                 arm64_sequoia:     "62052db50615cd82437c1275c560e4b2ff688324b84dbcc70b4add5d905e16cd"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3acfd2a76c834618ac39d10e8e767ae1a0b17e1b67b647eee2c9215c679caf9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a6d6accf0a39933539395527976a5aafec4f62bec83243aae818b311d1528381"
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