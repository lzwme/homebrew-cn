class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.76.0.tgz"
  sha256 "8df95144f7e1783bbfcdf50b2e0fedda06c469d5c21fb0b6f01416a6b14d893d"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88c85d0dc07e2ecc938f3e93006f2672450b76fa9d5a72d368e6a8057e73d6cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88c85d0dc07e2ecc938f3e93006f2672450b76fa9d5a72d368e6a8057e73d6cf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88c85d0dc07e2ecc938f3e93006f2672450b76fa9d5a72d368e6a8057e73d6cf"
    sha256 cellar: :any_skip_relocation, sonoma:         "03e619c2cb3fbf50c7d897192872968a6d7555a90fc15566b7b9e7f684a8c133"
    sha256 cellar: :any_skip_relocation, ventura:        "03e619c2cb3fbf50c7d897192872968a6d7555a90fc15566b7b9e7f684a8c133"
    sha256 cellar: :any_skip_relocation, monterey:       "03e619c2cb3fbf50c7d897192872968a6d7555a90fc15566b7b9e7f684a8c133"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a81d5d6f56c623867f57a0d6a3134e863a9ea09bb0594f42d158d987405769d6"
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