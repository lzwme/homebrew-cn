require "languagenode"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.62.0.tgz"
  sha256 "c7f5121a05979fb689b6431e91f4dfff3686060b8e671c4fb6adbdc28db206af"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2021ad93a8443e00eafaf0a8474cc9c60aac1d57bff9ba7a23d942049f33c6a7"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2021ad93a8443e00eafaf0a8474cc9c60aac1d57bff9ba7a23d942049f33c6a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2021ad93a8443e00eafaf0a8474cc9c60aac1d57bff9ba7a23d942049f33c6a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "a4c004a57062a498728f805d8a32b640062f006fb42e6b131c15aad6d0b9e71e"
    sha256 cellar: :any_skip_relocation, ventura:        "a4c004a57062a498728f805d8a32b640062f006fb42e6b131c15aad6d0b9e71e"
    sha256 cellar: :any_skip_relocation, monterey:       "a4c004a57062a498728f805d8a32b640062f006fb42e6b131c15aad6d0b9e71e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "195493cf27d570870ea67bfe069ceb4d13e917ca72dbefc76b7e395da10e26e3"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}libnode_modules***"]
    bin.install_symlink Dir["#{libexec}binwrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}wrangler secret list 2>&1", 1)
  end
end