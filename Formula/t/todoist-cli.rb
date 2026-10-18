class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.5.2.tgz"
  sha256 "bdee0c37a9c10357c2d6af2e9f5d699da2e0c31a6c2c5043f8b5d969bf8d1d33"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "500d25ead079ed555a67a7e0f87f5a773cc511040c75ace861cce8a05fece566"
    sha256 cellar: :any,                 arm64_tahoe:       "182434fc3703a3389b906b5cf42db3fc55a59816222808feb18562f9b898b748"
    sha256 cellar: :any,                 arm64_sequoia:     "0b9af9a7f2cae6cea60ff5db6ea6c528e5fe52e56232cef18eb938a224e187d2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "776d61e01e0d1b2627868d1056530a1a2516a6f8fe0fb9907aa006acdfdb482e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "10c8d20aea224c6330c368f4f9168b23b7ba83edc6c7a4779a28c03fbffeae10"
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