class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.80.0.tgz"
  sha256 "0962a894ab7b5a8bc64c0cdcd2dd4e347117100c20ea6e3e11a8762492ebf39f"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd5ad9474c00dad4cd413bcfefc85312a6293fb3a49a31b49c0cd97ac2505922"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd5ad9474c00dad4cd413bcfefc85312a6293fb3a49a31b49c0cd97ac2505922"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dd5ad9474c00dad4cd413bcfefc85312a6293fb3a49a31b49c0cd97ac2505922"
    sha256 cellar: :any_skip_relocation, sonoma:        "19cc2652300c97e032d16ba5679975b1e7d9802a2e240dff40d9700b05b8105c"
    sha256 cellar: :any_skip_relocation, ventura:       "19cc2652300c97e032d16ba5679975b1e7d9802a2e240dff40d9700b05b8105c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "179aa4b16b896dbbfda18ae03b8ea1d9d6c55ef88acfbde083953db91c20510b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end