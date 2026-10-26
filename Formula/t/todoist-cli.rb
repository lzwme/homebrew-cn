class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.8.1.tgz"
  sha256 "1a590f83e0078cdb3185389c350421fc8243daff5a71c8f354f66b87ad460365"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "b5083ea0629210010e1b2652d241d9b6ea6a85bd212f182915864c7d893ddbe8"
    sha256 cellar: :any,                 arm64_tahoe:       "e3df986f331c611b3817356186bb3f09463f60ab837ba10ed6e149c43b82eaff"
    sha256 cellar: :any,                 arm64_sequoia:     "a2d9e2a7218cbcb7d315c0e4392047e8b357ba5b808e39c3fed8ca46700abc09"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e08a515a88d99f2233551bd814c29f9499456b3000a0212f4fd53bcce6bffec2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "36c590a763dc9f4258338abc171f1278c16ed2f581fd576ff27072f4892625a9"
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