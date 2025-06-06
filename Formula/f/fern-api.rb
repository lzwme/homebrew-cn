class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.31.tgz"
  sha256 "8cbb3953c0a2b1b1aa17fbe82b99cc75de2ee30af82fbfa1b72df630ba9274ef"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2453b81378ea1d4b0765626d165a571f963fd0a95dacd472ad31a12f74074dd2"
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