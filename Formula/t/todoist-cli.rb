class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.0.5.tgz"
  sha256 "05ffc41e063904a12647f5b8ac8cbc573d62e79d8fe4e121ab2599ee5894b718"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "66c369b05075fc3aee014095ae31e38060f95280fc6721a5625a37151c4b232b"
    sha256 cellar: :any,                 arm64_sequoia: "66c369b05075fc3aee014095ae31e38060f95280fc6721a5625a37151c4b232b"
    sha256 cellar: :any,                 arm64_sonoma:  "66c369b05075fc3aee014095ae31e38060f95280fc6721a5625a37151c4b232b"
    sha256 cellar: :any,                 sonoma:        "bed5873a349baf277e498ec89e431cf9b00e8da9d049b68dc25d82f3969a1617"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "13bb775106620a12ef0aeef9e1789047a1cb816fb53daea9a20b83ace2ead163"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ff1c2bcb48a3425bef55304835ada229bd87e2ab0d7103afce136cfa4f49d023"
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