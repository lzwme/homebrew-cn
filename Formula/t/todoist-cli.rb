class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.4.8.tgz"
  sha256 "b5d7db319af52d4c173c504c0871f8fab3b1827e780824ab0513d6439631fe8a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "d24e260a7ce5b9bb601af638248b2c3527ef8f7212e4c1d836063f141d791327"
    sha256 cellar: :any,                 arm64_tahoe:       "7386e16cc64dae4ae2ede27f07c57d9926535f5e508c00e0f0e72fe322f37031"
    sha256 cellar: :any,                 arm64_sequoia:     "1a5824055d6f551e0d3d524bd7e76e05fa449ecc790e1d9ee409de4f95524623"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "91a3f5af02b9d4f8fdc7c7eddfa196bcff8957dfeddd3877170c16d0f1a5a15d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "939cef133a1d24b3a3b40cf99dfa7bb82c9423e692dbe912031fc87061220742"
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