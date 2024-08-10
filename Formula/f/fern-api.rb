class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.37.16.tgz"
  sha256 "defed523f458bf85f7765340f21d6d2146c87c09d4ec41d9bda3f163f938c5bb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3c6ca88165b47f94f2f41056ffa26847b6cc3d334296d1f76df8a21923046bea"
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