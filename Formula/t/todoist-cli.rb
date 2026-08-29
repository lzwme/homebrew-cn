class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.1.0.tgz"
  sha256 "d630291a2417de206f850eb43941442727605f2d961021a9739ac95707efc23b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "edce05dd11a8dcf69107ac3642cf2c7f0de13227639211e0ef2f892e4377a3d4"
    sha256 cellar: :any,                 arm64_sequoia: "edce05dd11a8dcf69107ac3642cf2c7f0de13227639211e0ef2f892e4377a3d4"
    sha256 cellar: :any,                 arm64_sonoma:  "edce05dd11a8dcf69107ac3642cf2c7f0de13227639211e0ef2f892e4377a3d4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b929648fcf5f4aaa385eb233d2317ff0c16383f4be2fda1da30125ffbf65970a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c514016544799ed18e1386f1bea24da6f1442266dde58b884e50ce45af01fbf"
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