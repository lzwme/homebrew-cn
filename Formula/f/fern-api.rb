class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.7.tgz"
  sha256 "31b396ba963fcffe9e818b1017eef25dc1391d69ea083139961e45f5510b3420"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5cc579e8c4d7c95cf2ed083e125ce7e64313970f6db04c8e7bcd2c7b6f16c839"
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