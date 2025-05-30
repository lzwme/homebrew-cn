class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.21.tgz"
  sha256 "8487305c1918d53e39a7af30d3673475b4ea0746c3aeac0d3cd55874afd56aab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ce4bb23b222db950b2019d3a95bcc07ad261ecc5e0e11a631eefc44c82305db2"
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