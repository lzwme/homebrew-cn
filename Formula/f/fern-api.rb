class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.95.2.tgz"
  sha256 "c82eb8ab4ccbce52ae635029a6c9b0fa2341153282984e531353500a93a3eda8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75bc4d8a3effcb6d8ed9c45bd94d1e9902621c0c38f6114137c061f1c604bc72"
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