class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.80.0.tgz"
  sha256 "3b85f653e2a079ab65c45aa1e91115c81d422d133c7f79be637cae1e6fdae684"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c733c6ff3dc2f2903f40067abaa38db2f7c269bbc33413b3cf54d6ecd96d342a"
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