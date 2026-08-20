class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.2.0.tgz"
  sha256 "106208ea9341386e75900c1fea4a3e7a7bc76ac017a222b5053eabb7601e1607"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "46b00035b6478d5019ae1f710fad3bc5e098056d2b6bb1fae08e07ac97baab99"
    sha256 cellar: :any,                 arm64_sequoia: "46b00035b6478d5019ae1f710fad3bc5e098056d2b6bb1fae08e07ac97baab99"
    sha256 cellar: :any,                 arm64_sonoma:  "46b00035b6478d5019ae1f710fad3bc5e098056d2b6bb1fae08e07ac97baab99"
    sha256 cellar: :any,                 sonoma:        "cdc69b1f020ff777321022adba01c678c4a42fdb04b61379df47b6e652c9f694"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c1b431b4c6452528c6a45a30ebe009dc165a28da24f08fd322f58e91f02faa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cdb075231883e33ee97a595d354de3e4ed4001af2d641b5c731a12391185cd57"
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