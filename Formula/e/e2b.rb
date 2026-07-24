class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.13.4.tgz"
  sha256 "691c0d3f3ea7696347611fc66626c4f79d1cf5ba98b999b69759d8690d876714"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "00f4530b071035062dc92ea400e87618bc90d89576af2942d771a918630ea673"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/e2b --version")
    assert_match "Not logged in", shell_output("#{bin}/e2b auth info")
  end
end