class E2b < Formula
  desc "CLI to manage E2B sandboxes and templates"
  homepage "https://e2b.dev"
  url "https://registry.npmjs.org/@e2b/cli/-/cli-2.21.0.tgz"
  sha256 "09cd1cb9d6de0966404abe5db9685809c6380fd77cc31b43f797f5fa5670250d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c1260e10e7f4fbf7ccfc5777f0d13178ce794157ae48ada25c38d91d6991ece9"
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