class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.84.0.tgz"
  sha256 "573acb4b2982c28cba1de7fc6ea9d1137934b59e77e97cb32cdba7a371a9570e"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bf72eda162fe3eff86a36e61cf2555d2aa83ba511c50de35925341f9d9667d35"
    sha256 cellar: :any,                 arm64_sequoia: "7af42174ad4ef083827d6bec26e849290a5bae645ffcb19db78a80fbacccbc72"
    sha256 cellar: :any,                 arm64_sonoma:  "7af42174ad4ef083827d6bec26e849290a5bae645ffcb19db78a80fbacccbc72"
    sha256 cellar: :any,                 sonoma:        "ba24db7a760d74ef0afed02b5b869a85aad103546f2103d6e3d2a45d21d98333"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bf08df1d0713e8a21062e5ae499af9fee465ffd287b34043660c65394ef777a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "545710f615436e781d8a2a2017d880d9842464ad5047fb41d6f9e2875057ecb3"
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