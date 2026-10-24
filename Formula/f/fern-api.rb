class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.172.0.tgz"
  sha256 "fbede61bc734b7fb5c98ba5f89cb3dbd60a7b0a3c33142e7cbe30b68424375d8"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "c2ab76ddfee7fd3d848e5580020dc09cdad5c6e7c7957b5ff66f91aab2f717c0"
    sha256 cellar: :any,                 arm64_tahoe:       "c2ab76ddfee7fd3d848e5580020dc09cdad5c6e7c7957b5ff66f91aab2f717c0"
    sha256 cellar: :any,                 arm64_sequoia:     "c2ab76ddfee7fd3d848e5580020dc09cdad5c6e7c7957b5ff66f91aab2f717c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "4b551f60d395827536f2b50777a1abbb0eae9af960eb9e71dcaef20adf95cef8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "3c6530fc79f9801a8a7e34bcc5688a45fc3860378450d19150be29bdfe271e82"
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