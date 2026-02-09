class PlaywrightCli < Formula
  desc "CLI for Playwright: record/generate code, inspect selectors, take screenshots"
  homepage "https://playwright.dev"
  url "https://registry.npmjs.org/@playwright/cli/-/cli-0.1.0.tgz"
  sha256 "83cc21857b4e76645b49b8cee4663cbc49b0c549ae3ead0f76cad17937f2df5e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e604719c0a26991e2efcaded1c698262ec578c271df814e35a394b3da4ea075b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bec28e36db0c76d65708e2f5779bdb6f90a5a6fe828f1185c84f7d54e1bd5c72"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bec28e36db0c76d65708e2f5779bdb6f90a5a6fe828f1185c84f7d54e1bd5c72"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5f342a4362fcefc614accadf5840c0cb484af0472e36d510bc416fc35cae0bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03ae1190bb32ee1efaed4c5349ea4c4b50849b49dc06f6d26f7a5f15bc149b9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03ae1190bb32ee1efaed4c5349ea4c4b50849b49dc06f6d26f7a5f15bc149b9b"
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