class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.62.0.tgz"
  sha256 "d96d170735413f770da177d41ee3524b36a94244c258f654d85c709562d56cee"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b8677ff7b84306a1f26f7bf2ae77fce1c1e755b1bb922daf51547279aa95b828"
    sha256 cellar: :any,                 arm64_sequoia: "2ba5c655373e705e18da06745409c777361298fa43f65e4557aff2e9685bebad"
    sha256 cellar: :any,                 arm64_sonoma:  "2ba5c655373e705e18da06745409c777361298fa43f65e4557aff2e9685bebad"
    sha256 cellar: :any,                 sonoma:        "85e041ccd15e3ebfe95b443645f7ba90a6bc07192d22afa5abbefb51b0273d8d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "484d4d3a989a81cf8a1af0e72c0d9185411f34c2f8c5eb98474b08d7e58fe8f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3f0e70ddfeef344d6453374f26e0fdf1074c32c77c1d72008e8f8e49796794d"
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