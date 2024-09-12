class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.41.10.tgz"
  sha256 "0651b3d79da07bdc0eec01232f3b177148435d929c0cf2a9b02489575d32eae0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "df86d1b605f64ae36ac2e02c334b9b38ec004de9d6e6722dd655306a961ab8a4"
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