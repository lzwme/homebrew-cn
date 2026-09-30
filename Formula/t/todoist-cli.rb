class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.4.3.tgz"
  sha256 "7074b3586c52785ea2fd09e0b568333c952821699a8a8ebd85e0a878fcf4396e"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "4bac3c01a0971d884aaf834b1d19716d35e69f6c9159dc2007e0c40b3131421c"
    sha256 cellar: :any,                 arm64_tahoe:       "d61faa7084daeed286f13740fb3a9e21138f87a243cc1cd8c67bc117eb7f0de8"
    sha256 cellar: :any,                 arm64_sequoia:     "4349ba63a3800b72fc7697bb9e71d63394b104a9f6922e37c53ffe5373dac77c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f641d453201c355008eb15b7800ce493010ae0c121469277c76990a8de0d52f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "bcf7f7a88c2b2aed94c894f1a70fad4b6f9a55a10f00dca804d1e0b4e0c91403"
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