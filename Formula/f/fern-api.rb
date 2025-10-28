class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.98.0.tgz"
  sha256 "f0024142445566e585db6fb72dc767692e15da8c80c1ba464f67c09fefcd87a5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e860c6362af0c129020dbc594c73864bb323a3ab7232eb768facd387e2e0899d"
  end

  depends_on "node"

  def install
    # Supress self update notifications
    inreplace "cli.cjs", "await this.nudgeUpgradeIfAvailable()", "await 0"
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