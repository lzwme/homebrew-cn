class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.5.tgz"
  sha256 "c4126d8af0626f91bf4b86d28007d2326d5008da8927fa0d76916b290d56af84"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fae7ebef8b9c8aa9d8f787d3ffaefb1870c4f6a2061b3f75b8f1ff35d12909b9"
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