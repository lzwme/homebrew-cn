class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.15.tgz"
  sha256 "1abebbea7534253149c1db71ee48ed04fe4ff890a1ec1b6abc85ca0597ae5457"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa773d8742469a1967c9bf35248af93784a22cc4fbe285ad9d16553093fd5e52"
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