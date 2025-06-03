class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.26.tgz"
  sha256 "7694e468743b2c37e5d4d481e0e2284ab8e6c8b5c853e5a040e3a3f637f7934b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c8e9c5ca3a006900ca31503d236bf9944bdd2c02153234428955ee2188bf767f"
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