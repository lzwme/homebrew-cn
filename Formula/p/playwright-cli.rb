class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.2.tgz"
  sha256 "ff1c0e12c78981d12e95b10dd8f60246ab4772de8e15a40452b2dfbdc0b60e38"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30afc2724cdff7d53e8f312c24e3d78e2f54702f49ee4347c01234e10c8d2473"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "630276af788fb11734853eea94e1b6d79a76f8be8138bc9603021ddd28483f9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "630276af788fb11734853eea94e1b6d79a76f8be8138bc9603021ddd28483f9e"
    sha256 cellar: :any_skip_relocation, sonoma:        "8085690291e6395f93cb639e80ec60f6956136268eb6a4df28b5134f3d6e9911"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75f4cef26c67cb639f6b14f455a0c609afa0a98fb5a006e62a6d143947bd3863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75f4cef26c67cb639f6b14f455a0c609afa0a98fb5a006e62a6d143947bd3863"
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