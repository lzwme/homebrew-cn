class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.57.34.tgz"
  sha256 "81c7f8855060dc5ba49e4abe51cee2405a86cb520901eb2af40a3b89036b744e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab535f56e716411bed44564dbd1d60e71d1c54571a80ccfc3d850de19cb8618f"
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