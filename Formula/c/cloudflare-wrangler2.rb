class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.71.0.tgz"
  sha256 "f44294c6d26e3e607001c21690d81e8e54c5fcacae2d54c91d696cd364f55ed5"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c623064b2d3a9df7b1a117ee64af6082bf5dd344f88687c9477cc8f63066cd6a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c623064b2d3a9df7b1a117ee64af6082bf5dd344f88687c9477cc8f63066cd6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c623064b2d3a9df7b1a117ee64af6082bf5dd344f88687c9477cc8f63066cd6a"
    sha256 cellar: :any_skip_relocation, sonoma:         "6d8777e53eeb1b85d1112b1b63a0ac769b6d88204b5231502fb104e9b02a80cd"
    sha256 cellar: :any_skip_relocation, ventura:        "6d8777e53eeb1b85d1112b1b63a0ac769b6d88204b5231502fb104e9b02a80cd"
    sha256 cellar: :any_skip_relocation, monterey:       "6d8777e53eeb1b85d1112b1b63a0ac769b6d88204b5231502fb104e9b02a80cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a0256a31eda25fd87c1caaace52d9d6d5b5837f3d2c8f35d8ac4739dbf68f01"
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