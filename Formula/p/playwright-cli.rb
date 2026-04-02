class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.4.tgz"
  sha256 "2355d1e33796e29162e3eac2bdee950b9f48abe64831b57bd79bed3b9f327f62"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db750a64b947d9f753b37b07d637ed395d27efe22e5f49c24342b005cea55a43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b233132b4b28e17fc8bddc471dd1cb262eaefd6810efca31167a70f8e34a53ca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b233132b4b28e17fc8bddc471dd1cb262eaefd6810efca31167a70f8e34a53ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "36d9ae58ee1ce14bcfef8f35015670068c226bd1ab4c6d2c46d367042cc41ad1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a508b5e59391dc573fcf430f778066b641a38b863857446b846dca65c60bd5fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a508b5e59391dc573fcf430f778066b641a38b863857446b846dca65c60bd5fa"
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