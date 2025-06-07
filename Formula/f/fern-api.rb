class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.63.38.tgz"
  sha256 "415e685c7b08f81e9f81764353bbb6350b6347a1781c4dab95410742c0b8d00b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3b4b9d5d0e40103b87ebdecd0786a146c27888be5e82036943a153642ea6195f"
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