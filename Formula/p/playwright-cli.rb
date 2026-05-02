class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.10.tgz"
  sha256 "de5e3fcea9bd540d6beb19ab027a272754c1a21d7b3bbfca3475402894dd7522"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a7e2dc6dbe58e605912f5cab4ec7e681f7c9bd65c4d60b0cfcd5a9219a1f5c4c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8ffe5c5482c14b9d7906ad562e6346a836242ba62781af1cdc6a9b9e53751dd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ffe5c5482c14b9d7906ad562e6346a836242ba62781af1cdc6a9b9e53751dd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "33056593b6ff209b41d7d9b39408b9e7a0654e5d3c0828c12365fc73fcfb9716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98e89aaadf916314cfd764963f4821224620e6e242950690e822af3bb5f83557"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "98e89aaadf916314cfd764963f4821224620e6e242950690e822af3bb5f83557"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    node_modules = libexec/"lib/node_modules/@playwright/cli/node_modules"
    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/playwright-cli --version")
    assert_match "no browsers", shell_output("#{bin}/playwright-cli list")
  end
end