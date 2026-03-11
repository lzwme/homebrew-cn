class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.22.0.tgz"
  sha256 "b60c49ad5ddf7ee13a4687250ea078f24dfcb302c5b56c8ac48fc693d9f85557"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6a6ca32262dedee6dff92fd081988ca7cf019f9b722055001a7498652ce2646d"
    sha256 cellar: :any,                 arm64_sequoia: "9403b6793518627ac3b47355e73540cdf89fc8ec1620e4db7eda8500d0ae4e97"
    sha256 cellar: :any,                 arm64_sonoma:  "9403b6793518627ac3b47355e73540cdf89fc8ec1620e4db7eda8500d0ae4e97"
    sha256 cellar: :any,                 sonoma:        "dcddf9e19179663444262090a3478080ec3b33ae05257b940f7a3b239b63dc4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4939c9e99ba0df832b766962b964b7db31aa374112b88eb3f69d86a45d491db2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bf90fcc561bd494f1eb7aef906aa3ba98f049aafb419ec9b9725a7e29fe7a632"
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