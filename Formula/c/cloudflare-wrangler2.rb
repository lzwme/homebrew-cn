class CloudflareWrangler2 < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https:github.comcloudflareworkers-sdk"
  url "https:registry.npmjs.orgwrangler-wrangler-3.88.0.tgz"
  sha256 "f5f90dd2ac413981974e13e91bf7b32c8bdc70fa64a4fa6a34994cf8f32756a3"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "104581855ce59ce266de5bb65873acf521b90c6e975d5b19d0135ac69a69f5dd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "104581855ce59ce266de5bb65873acf521b90c6e975d5b19d0135ac69a69f5dd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "104581855ce59ce266de5bb65873acf521b90c6e975d5b19d0135ac69a69f5dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "eca3ef3face185601d069c0e2b48daf68213141bfef049c2e6b0f0ea7e89f08b"
    sha256 cellar: :any_skip_relocation, ventura:       "eca3ef3face185601d069c0e2b48daf68213141bfef049c2e6b0f0ea7e89f08b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "036f41d6cc81d57c64bcc37e0d110c0fe4044677fd488d20f740de74e4923b15"
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