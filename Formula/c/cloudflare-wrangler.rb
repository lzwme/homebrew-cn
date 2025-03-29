class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.6.0.tgz"
  sha256 "3a78e673370cd45f158b9d44326621e42cc54d080652bb9bbc3873a607bd66b7"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9de9a74654109d5493e6bbdaace1355fab49c7d0837cee033a24595a675e87e4"
    sha256 cellar: :any,                 arm64_sonoma:  "9de9a74654109d5493e6bbdaace1355fab49c7d0837cee033a24595a675e87e4"
    sha256 cellar: :any,                 arm64_ventura: "9de9a74654109d5493e6bbdaace1355fab49c7d0837cee033a24595a675e87e4"
    sha256                               sonoma:        "924b896cb6613df07737289b6fea3bac9be066580e996950b05858e84abb88aa"
    sha256                               ventura:       "924b896cb6613df07737289b6fea3bac9be066580e996950b05858e84abb88aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9fb470846f6d9dd641ef9b3a6fb138fad5fbda9817487786754cc4d9b95b1e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d66b35279a4f41144ec2637f1b98a5fc633d76f33f99c66eef71485a4119518"
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