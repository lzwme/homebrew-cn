class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.26.0.tgz"
  sha256 "f8f7e6c48e347013a90e940cff10c0eae8daf320ff3ba389521ee00f4b2c07b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3e1cbb23fefb977300ac843b3a36098a961b609bc9784390f069325b5a7ec0fc"
    sha256 cellar: :any,                 arm64_sequoia: "0aba281cf88d3da6a2960198ca45aa4cac8080738d6006fa221e08738b8bed63"
    sha256 cellar: :any,                 arm64_sonoma:  "0aba281cf88d3da6a2960198ca45aa4cac8080738d6006fa221e08738b8bed63"
    sha256 cellar: :any,                 sonoma:        "ea40e2745beffc02ac4923d64842056384ea2c7f865411c142cb37d1b4650e7b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93ce2aa602143b1a3b719022922c7fd28fa52e3f226ea5d6ea2cdbc36ee336ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "77f016129f65eff8cdee9dbd8117850ab967ce7e8d146c363da45bf6fe788797"
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