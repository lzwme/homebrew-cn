class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.5.1.tgz"
  sha256 "d0ad1b99ad9eba010f990ca319539410570bbc45a5f709a0c46f45b023434169"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "707784c7216ba8aef584df7e9fcf11d049353451381fe62b3a2a54a9e5ce8e42"
    sha256 cellar: :any,                 arm64_tahoe:       "0f34042caf0b2a416a6170b1a8b2480912942856db21686bee4bcd270d5d8fd1"
    sha256 cellar: :any,                 arm64_sequoia:     "985d6edada2391fda6cb0a512eaf37c06e5e334e7e97ba7538bf0fe7cd26423c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5ec60f6c7c2487d28f63ee4f6bdf2d93fae0a07303bdc8f85cdab9891c58987d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a551a316b16857bdde24055012eb61412319476c86452720288f466a6890c53b"
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