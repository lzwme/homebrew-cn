class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.75.0.tgz"
  sha256 "8229b39a69dbb7524b51f0f54e2e1065a17ae752e478302407f1ffe54559d603"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c61b91df1e2b1e265e778373fbd21abd91960c81a9d4c320a85a5bcfc81fb1a"
    sha256 cellar: :any,                 arm64_sequoia: "4c61b91df1e2b1e265e778373fbd21abd91960c81a9d4c320a85a5bcfc81fb1a"
    sha256 cellar: :any,                 arm64_sonoma:  "4c61b91df1e2b1e265e778373fbd21abd91960c81a9d4c320a85a5bcfc81fb1a"
    sha256 cellar: :any,                 sonoma:        "04c50457efbdbdfcda21c472aef0de64ddb241f128bf3e246be52b2df7bd669f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92e2ec06f9b50e2c890b91512a7a39d3ed811dccad9d9e088d80f9854139857e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89d2963c5a6542a057430d05c7766fbb245e0a809374a9d0cbfa73383daef3b2"
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