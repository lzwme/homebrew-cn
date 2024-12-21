class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.10.tgz"
  sha256 "5c69c50fe8f642de43b4aace15e8539d595a9ff38c7dd4a566c996f368bdf4ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b43e110c4f9f718a0fe92dec4cc91a99837f89f4f548dd3aef79789264f2c6e9"
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