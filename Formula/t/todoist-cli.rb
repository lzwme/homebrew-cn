class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-1.73.3.tgz"
  sha256 "bebffae8d3a73aec1330bd0117fba814eded030606469c876d9f86ac40e2d569"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2812e781b8cb0da940213c296dda7b447c56b44c7903e8f038b5defd393a97af"
    sha256 cellar: :any,                 arm64_sequoia: "e5118a661d00b0684826d301112633aac4da58b8eb708613889de2882dc8a99f"
    sha256 cellar: :any,                 arm64_sonoma:  "e5118a661d00b0684826d301112633aac4da58b8eb708613889de2882dc8a99f"
    sha256 cellar: :any,                 sonoma:        "72104ea435f1584d47e76a1d19f89b26ef704879ba7cb78d1e55d5567cd7f175"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5f884826f603299686b08c56e1f07790a277f4ebd69d288b765d6063ee96388"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15142f304fb4fab2ab17b90adc9b36cdac0abd8decf92cfe9528b547c44031cd"
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