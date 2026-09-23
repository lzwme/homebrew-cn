class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.3.11.tgz"
  sha256 "ef0daaaba8005b5285a22aa6e5f58fe6517f183c8ae196791a897ad9f6ddac6c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "546afd8024993712cde2edb7b6024250a2161b23d2a02f14b5f5cad594decd60"
    sha256 cellar: :any,                 arm64_tahoe:       "58016bec268f60aa0e79f7f2353532f7581e54c141dd417286cc02b90e7a8dfb"
    sha256 cellar: :any,                 arm64_sequoia:     "c5f06cbfa961bd1b530004b4543f3470323041570dc8d095e526dc4492a846e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "2aabb8d7b275052b8d39e434ecc31b91aeb53ea800a58ae84f372f720b684598"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "629c0f8f5a2fb4a205837fe94426c58098c82642872269b70fe175cb7b8c67d4"
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