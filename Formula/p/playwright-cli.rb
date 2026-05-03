class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.11.tgz"
  sha256 "7d7b3cce1e42affaba7e168699e5aa19d87801a4f336497c70fd230f507baee9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "04ca012cb030f98466b98338e92e3f6b9e6b98a19183be57b516181563b62c44"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "afd1ea817d9095b5620b02253bd8154d78ad145a88379c1a2d31657a899f06a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afd1ea817d9095b5620b02253bd8154d78ad145a88379c1a2d31657a899f06a5"
    sha256 cellar: :any_skip_relocation, sonoma:        "e6d804b7db36b649e094828e04594caf6b553e3e7f209e77c23333d85d710ea7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c7124e0e5574c548210c80e1b29403b1f6e2a98ee5e90755578571cdcef2be1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c7124e0e5574c548210c80e1b29403b1f6e2a98ee5e90755578571cdcef2be1"
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