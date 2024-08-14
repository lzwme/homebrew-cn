class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.39.1.tgz"
  sha256 "0a5261923d12640c408942a459ee8a78e49fb67dbe49cb51bfe061eec9b6c481"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f893339fe9a2f62fdd893c3c840ebd1e0e760d22c4f248e0a91db9265b8eb4d4"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fern init 2>&1", 1)
    assert_match "Login required", output

    system bin/"fern", "--version"
  end
end