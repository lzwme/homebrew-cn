class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.160.0.tgz"
  sha256 "b560a282ed784653adcda611c8a769b5d6cafd24b71d1c5ed2042ec98e05ca0a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "3ba16b9ff53b87a8327ab2f058cd0659d017c1a49231708c4bbf46de99fe5735"
    sha256 cellar: :any,                 arm64_tahoe:       "3ba16b9ff53b87a8327ab2f058cd0659d017c1a49231708c4bbf46de99fe5735"
    sha256 cellar: :any,                 arm64_sequoia:     "3ba16b9ff53b87a8327ab2f058cd0659d017c1a49231708c4bbf46de99fe5735"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c063715dc826a1cb4d05a0d13bc254d167e5b106bc417c78e62c2cd9bc82cfe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "de48f33bd424fc51d96e39e9275255ffff4a4d15cee7769e9045875d2bd1587d"
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