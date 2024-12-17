class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.46.4.tgz"
  sha256 "4aa86597d026237c46dd6fd5ea31e3acf3cd8ee35de3bab7321ce945275f73fc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "885a9a5414f51fa76237b37addc4426daa4c9a94b163efbba2a01515c02bf8ea"
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