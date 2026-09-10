class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.3.0.tgz"
  sha256 "bf8870772bada11bf8cb93e60f3eb0512ee6ad9a50075c1f86319bb25cfa2eb5"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfbd83f9114ac0f46eb1eee6b545d010b25cb0f2d6dd16af07a0370b7ef709ac"
    sha256 cellar: :any,                 arm64_sequoia: "580b22f7c4994e378d667c02914fe598870f67a5b30ce8ce5043ff2da0a37f97"
    sha256 cellar: :any,                 arm64_sonoma:  "e3987cdd0cde6e9aa7441c0a9b093f82a998313387fa5b05f66afe87f04149fa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f0b4112a13dcbacc922d1c423cc622cff9a0d9eeb7735eafc04312d4ac5ca91a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb669cdf5b9714a7c6067a9635b11ab7f68d067d0449a11fcc78d6027bb7d753"
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