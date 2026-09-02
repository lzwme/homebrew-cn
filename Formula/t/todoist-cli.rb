class TodoistCli < Formula
  desc "Official command-line interface for Todoist"
  homepage "https://github.com/Doist/todoist-cli"
  url "https://registry.npmjs.org/@doist/todoist-cli/-/todoist-cli-5.1.3.tgz"
  sha256 "ae72ba195d98a6241208b7d6a484ca3a59dfcdad62f9a30dc2d227c158a79434"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "48e1fe983f883710a35ef4b3a4d8ee8b28a96e11bbccba56ec8d77afdcb94726"
    sha256 cellar: :any,                 arm64_sequoia: "48e1fe983f883710a35ef4b3a4d8ee8b28a96e11bbccba56ec8d77afdcb94726"
    sha256 cellar: :any,                 arm64_sonoma:  "48e1fe983f883710a35ef4b3a4d8ee8b28a96e11bbccba56ec8d77afdcb94726"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2272ede00aa005bf62e4b1083e63efb7fc014c0c3f33a1a3c15a1ff3dac24a77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "efc4cc4bf25e596a561afcc2b09eefda10a80ed147b0673de76ca970677e5386"
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