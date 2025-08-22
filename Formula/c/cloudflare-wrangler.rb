class CloudflareWrangler < Formula
  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-4.32.0.tgz"
  sha256 "721adba46551dcc93e850a1a42a3c4257d202b64df9b9817c307e62db5fd5169"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "bbdcdc274d89a058037a106e98bdc3b37a354d2963f48f98fe93852977612a85"
    sha256 cellar: :any,                 arm64_sonoma:  "bbdcdc274d89a058037a106e98bdc3b37a354d2963f48f98fe93852977612a85"
    sha256 cellar: :any,                 arm64_ventura: "bbdcdc274d89a058037a106e98bdc3b37a354d2963f48f98fe93852977612a85"
    sha256 cellar: :any,                 sonoma:        "bcd238558b365be8a05ee9bcc919c858b8187fe3423963d6994e562d2c54d76c"
    sha256 cellar: :any,                 ventura:       "bcd238558b365be8a05ee9bcc919c858b8187fe3423963d6994e562d2c54d76c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52dd18eae73f3a67024c7cd38696f381a8b762eec9987960ec602b2473b81ce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afbfb335dd8342c59333fbf1f345f0a225b01d2fae0db124d5392bdd718c6add"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end