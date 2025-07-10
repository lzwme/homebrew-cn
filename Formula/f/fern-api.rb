class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.6.tgz"
  sha256 "321923cf0fa5076faeeb42ac8d442038689d6c20b6fb1e0d6bbb2b925c84bde7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c1b87106c833a2b7c3f67459f46c868091c566d266dc9e3da9e357da47ac81e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match '"organization": "brewtest"', (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end