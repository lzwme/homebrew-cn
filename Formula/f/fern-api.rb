class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.65.9.tgz"
  sha256 "0e24c450e5bcb77684ee1d3d34df0cddb49501ebe2bdbeb25d172d7fce31d82c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "effd9fb970cf6d4b13895484654b5579381f25c6dc8e48894d6ffcb586b48cd5"
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