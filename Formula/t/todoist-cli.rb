class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.8.2.tgz"
  sha256 "ce858183cb90b7718f4d08b95344cfac671e610f658fbe758e4b27dd82d3efaa"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "3e3d816de21084038e9869941db57e30e9c610a74d8786d35351b9195b4786f7"
    sha256 cellar: :any,                 arm64_tahoe:       "3e3d816de21084038e9869941db57e30e9c610a74d8786d35351b9195b4786f7"
    sha256 cellar: :any,                 arm64_sequoia:     "3e3d816de21084038e9869941db57e30e9c610a74d8786d35351b9195b4786f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a6718406be7adf0eb9abdcc7c3e418319829b1167dd2a43d3ad5a8b7634f723"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "d466629f09ff9746d1f8740273b4ae60acd945f041ad9bad83142fd5727e3d0d"
  end

  depends_on "rust" => :build
  depends_on "node"

  resource "keyring" do
    url "https://ghfast.top/https://github.com/Brooooooklyn/keyring-node/archive/refs/tags/v2.1.2.tar.gz"
    sha256 "b461a450df324a73219c6352186b95e4501b3f9099b876b023c9cdcf1d8cbf9d"

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