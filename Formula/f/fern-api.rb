class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.15.tgz"
  sha256 "d5fc87949a129d5377d6b91153ce9d25bb563a1503a511db38774ab6b0d19810"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d964c970667cc85c3cd210018a030965b909a7e62ee6b3de1653805ebf2ec989"
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