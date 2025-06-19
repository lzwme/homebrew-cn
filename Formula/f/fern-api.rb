class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.12.tgz"
  sha256 "7a30f71fe99737b4f3e23bd3163d96980d634ce55bb6cd1ec7992e4ca12efad2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f7e3a489fbf5153316d88853f3eca5394aa7c1fb83862bca2eefea1288e8ea0a"
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