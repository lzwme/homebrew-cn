class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-4.11.1.tgz"
  sha256 "ca897a21898bd1be61d68fb2e332e79de5626f58e3422076081e7dba507d1037"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33a20f3540e3dc70c2b8e600e16a488516d0abe253c67d227504c75ed81f1039"
    sha256 cellar: :any,                 arm64_sonoma:  "33a20f3540e3dc70c2b8e600e16a488516d0abe253c67d227504c75ed81f1039"
    sha256 cellar: :any,                 arm64_ventura: "33a20f3540e3dc70c2b8e600e16a488516d0abe253c67d227504c75ed81f1039"
    sha256                               sonoma:        "6b036d21db27b87537c9d2b7b267416d039476821b9b5c00247780c107cfe18d"
    sha256                               ventura:       "6b036d21db27b87537c9d2b7b267416d039476821b9b5c00247780c107cfe18d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e8cba621b4baa6907fc6b58d202b5d6a4cd2162fe229f947c2a0d91941e3c295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "22fe63025dfce04aa6c96d632a0212ca1845f4ed60077e0fc1b3b828b2f735c4"
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