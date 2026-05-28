class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.69.2.tgz"
  sha256 "cc0fb21de14ebede5238b64809236b239f381a9793af49d38f2cc2ec451de192"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c7300e09325453438bf8f8fb1da252f5f240db41c0637f43ac1f685b07f31f47"
    sha256 cellar: :any,                 arm64_sequoia: "87dfac51f5746640a535e20f52c5bfa75eb5d71e3de076293bc7431860ca1f1a"
    sha256 cellar: :any,                 arm64_sonoma:  "87dfac51f5746640a535e20f52c5bfa75eb5d71e3de076293bc7431860ca1f1a"
    sha256 cellar: :any,                 sonoma:        "6fc0d9831a6337070f6b054f78da0b035670e4861113e7cb760d37fa723d5266"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27960c9d7224c0d7fb8d171ab5a2c61384c78f3c1a3cf1f607b8a2385f80abec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b07373ae6e7994706c18fa90e317fd8ed2dac0283dc4f7cdee208762a3a20be8"
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