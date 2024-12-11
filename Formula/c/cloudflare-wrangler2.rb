class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.95.0.tgz"
  sha256 "a2c4f6af8edf2264e97758d633a24e6ad84b9511857ae7979eab9947ac2dd220"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "24394980ccf292523f9d723f7495e366ad9d1def66341bd7f2c5346653442a8c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24394980ccf292523f9d723f7495e366ad9d1def66341bd7f2c5346653442a8c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "24394980ccf292523f9d723f7495e366ad9d1def66341bd7f2c5346653442a8c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3072a6a911aae7aca42b8c5165dd1bed964edc6f29e77439c050a4b0a078aab2"
    sha256 cellar: :any_skip_relocation, ventura:       "3072a6a911aae7aca42b8c5165dd1bed964edc6f29e77439c050a4b0a078aab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "689bec0ae9dc84553cda5b02d45aa5bc3423a58e22b427d72fc288d91553e770"
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