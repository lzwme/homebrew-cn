class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-4.0.0.tgz"
  sha256 "aa14eecdd1f372539c5a8a8c437b666ce9b51b79f9bf09b4242c7d31e442697d"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "87b918783f29e31eb7a4782cdc25e68be74adcd8670b4c58eeabf75bb6c9e20f"
    sha256 cellar: :any,                 arm64_sequoia: "87b918783f29e31eb7a4782cdc25e68be74adcd8670b4c58eeabf75bb6c9e20f"
    sha256 cellar: :any,                 arm64_sonoma:  "87b918783f29e31eb7a4782cdc25e68be74adcd8670b4c58eeabf75bb6c9e20f"
    sha256 cellar: :any,                 sonoma:        "a1e5124755479e1773053476ce4fe200b546905f3a7926108e36caa0259e84e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fc5b1c267fd31836be26436829f4d28358f16c8d3b33718b8b1d0f9000f08438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "909f18cbb91d3dd0c8d84d3b46248faecb83d81e5c39cc72bedf6c0b50758f9a"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    return unless OS.mac?

    deuniversalize_machos libexec/"lib/node_modules/@doist/todoist-cli/node_modules/app-path/main"
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