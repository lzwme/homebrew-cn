class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.10.tgz"
  sha256 "18b887650e031f757b86ca909873c0dca7ea36147dbe1c6870d924b743312d58"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d2ab676e03ef5e2d3b1cd92fb003fb8d08cbc05c56bdded0d8d9a8a1b876f962"
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