class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.10.tgz"
  sha256 "e18c508ec339ceab0b6e32dd6226f4ad3ddb600a45bf965f1831ac3b950a7bd5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "dee3d6cb1b9e6444723058477a7d90aecf87fedb6114164123baf0397eb4a728"
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