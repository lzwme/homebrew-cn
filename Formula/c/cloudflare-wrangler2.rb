class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.70.0.tgz"
  sha256 "ea24114cd880be46c457db6e0313b061def5352c727c980210f5e7b2ee0fdc5c"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "caf476422625fe4db0c741e1497c1f5c6bb35b3c104a73de8043a9214bfe6afa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caf476422625fe4db0c741e1497c1f5c6bb35b3c104a73de8043a9214bfe6afa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "caf476422625fe4db0c741e1497c1f5c6bb35b3c104a73de8043a9214bfe6afa"
    sha256 cellar: :any_skip_relocation, sonoma:         "d928310595153cbd2d0c81832896298776dc1a926036852fd8ef2d363bfc22f5"
    sha256 cellar: :any_skip_relocation, ventura:        "d928310595153cbd2d0c81832896298776dc1a926036852fd8ef2d363bfc22f5"
    sha256 cellar: :any_skip_relocation, monterey:       "d928310595153cbd2d0c81832896298776dc1a926036852fd8ef2d363bfc22f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49f5236686cd4480e4fa0bcc0b883382a5bd439c37a806332b68227733eececa"
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