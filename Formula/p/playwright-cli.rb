class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.20.tgz"
  sha256 "877a33d75831ad6ab4e30ed358e19c178747f14834d5fa6e5dc2a294787c06d2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ca479bd373a5e27f41a0eb311b68da454981e2fd20936ed850306914573b78b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-cli --version")
    assert_match "no browsers", shell_output("#{bin}/playwright-cli list")
  end
end