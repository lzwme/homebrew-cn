class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.19.tgz"
  sha256 "0a6fca06371fa7e69be33f6730f78d7bdd69d037390045c4050e961e8b1dfeee"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0418afa65ea41cf4eceaad8ec91ff1528fee9030e658d8dcc54891e0c3090137"
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