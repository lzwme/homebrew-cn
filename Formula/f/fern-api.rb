class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.64.25.tgz"
  sha256 "c90d22ce46dc5ca6f14219e0decd52b36f28d9543202b533929b1e8a11bbdd8c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f26f7b644e5012aed6532f92247a5e5d430a40fcef4cbf52ba8d41c80ba11256"
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