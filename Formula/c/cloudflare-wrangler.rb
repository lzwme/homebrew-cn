class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.14.0.tgz"
  sha256 "109e2f6ebfcd37a12346f9147bc6475d9fd675ddc964bd4c14a7bb6e286ea421"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cfb46ce06d20cd977209ad54ee7db555e23517c8b32cc988a119d94124cf62b4"
    sha256 cellar: :any,                 arm64_sonoma:  "cfb46ce06d20cd977209ad54ee7db555e23517c8b32cc988a119d94124cf62b4"
    sha256 cellar: :any,                 arm64_ventura: "cfb46ce06d20cd977209ad54ee7db555e23517c8b32cc988a119d94124cf62b4"
    sha256                               sonoma:        "7edeee0a7db3dde04124c8dc8aa62e5f77d844f158b6434f714e083e64a3b011"
    sha256                               ventura:       "7edeee0a7db3dde04124c8dc8aa62e5f77d844f158b6434f714e083e64a3b011"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "46e4945a0c9c994c727c8a1f07e1a09fba1a9d6abb3801aa6d1d7232991bba14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fa02c7b7872d2a3039dbec37cca1f7c9bae970c90f9e153e3af514acd37b4eb"
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