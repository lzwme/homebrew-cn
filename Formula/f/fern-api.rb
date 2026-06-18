class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.50.0.tgz"
  sha256 "4d3cfced0f641e6bcf912683bed1f59fd37ad18cf9dc2f54f54aa2d2de52e40f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c922169b00bc95e87e7386bf2568a739413a5d01ad0089bfaa2dc467d93cb457"
    sha256 cellar: :any,                 arm64_sequoia: "065adf487c9963b1bc6aeab18abe07a025f8b74270be72caf245d4d38dd7d525"
    sha256 cellar: :any,                 arm64_sonoma:  "065adf487c9963b1bc6aeab18abe07a025f8b74270be72caf245d4d38dd7d525"
    sha256 cellar: :any,                 sonoma:        "8fe5386e6d6b983eeb93d610f3977f903dccd187f6c7d1b9792c3f41ceede192"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2057b58b51a7f891a63bca92ecb4ca0abbd1b73fff70863ccd61e32c30eeba4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0042bbe1ff163482fa33fb3e9ee8d033b15780e7f17f44bf11ae893ec3dd93f"
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