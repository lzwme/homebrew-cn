class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-3.3.2.tgz"
  sha256 "aaacca880a0ca96d432bb2915591a1597786a29f696bac5646225fc61385389c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61453318461fa9322541a05814151c7f99e6256e9e4440d7e55c532badb04fb1"
    sha256 cellar: :any,                 arm64_sequoia: "61453318461fa9322541a05814151c7f99e6256e9e4440d7e55c532badb04fb1"
    sha256 cellar: :any,                 arm64_sonoma:  "61453318461fa9322541a05814151c7f99e6256e9e4440d7e55c532badb04fb1"
    sha256 cellar: :any,                 sonoma:        "80276329926e5be23b86f3f2ada56fd88ffd164aba08c5826e77e248d7c7e703"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b83d890d85f39a8cc222668f20891b237291565b37433132372c7abc8810560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b0592dcd9c1cf18f8eaa8dda44f07beabb6f72be372b858fa8eb41ebc1cb389"
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