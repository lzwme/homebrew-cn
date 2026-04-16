class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.71.5.tgz"
  sha256 "e674e2d3df388dc21e7359d33a6a9bb55f94e481eccff97e26e5149446cfe81a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4dd896a3c9ec97b3c4b495e229f1c1cc11a6b4064e5c90e2b4d31e3716359ff5"
    sha256 cellar: :any,                 arm64_sequoia: "bd6097afcc21a6fc74769f8f637bb44f24259598aea11eae893e643ffa897d80"
    sha256 cellar: :any,                 arm64_sonoma:  "bd6097afcc21a6fc74769f8f637bb44f24259598aea11eae893e643ffa897d80"
    sha256 cellar: :any,                 sonoma:        "b8fac2b8c80825a439e7bd245aedab1a607bff7ebf14a527124696f76f66c361"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfab310cb0336bb3638b95e6cb93a711f6c6fb640c597deb3fafcafbab2e6aba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5da30573ed3493d023e32c5671274f824bad9f88937d56ac78491a5fbddc3b77"
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