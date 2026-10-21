class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.5.3.tgz"
  sha256 "6892c8c9163653e7ff5768ea5e6db520e736922296d6155ef8f124da396e1530"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "deaddefb71cb39a685fc77adb67cf35a916a39733cb4f2c4dd7d82615dd00793"
    sha256 cellar: :any,                 arm64_tahoe:       "8bc6b10a1ae5a7956b4941d75be74dc1856bbc5fe6df56e23d0a857ab21ad9f0"
    sha256 cellar: :any,                 arm64_sequoia:     "bbaa77750e93e9ca16169ee12b5f9486ba7cfa31dbfeb2ddfd90351cd3efc913"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "706814d1c3a13a02fcfe91588342ae4a0f3cb52622d8d2ca979d040bf58af80f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "f9aa51a122d33bf873273a12fdd0dc687c2d3dd14fbbdbbf120204298b1ab902"
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