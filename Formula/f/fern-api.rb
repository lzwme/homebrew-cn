class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.41.tgz"
  sha256 "452a1d74e0aef734133c0fdc81e68397169ff0538616447fca7ff2719cdd8778"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6bacd81d9e0473f49866d414fdcc1c47585869c907650c483d53ea0a0bbbf652"
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