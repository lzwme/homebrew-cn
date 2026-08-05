class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.90.0.tgz"
  sha256 "aa573b31f8dd99c5e526496a53092470ba1d6f3a4e60cf895d069f68c0a5a101"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f4ec6ff0a4efd798c3534357f1b9ef94b8951ddbef051752f30972deafd2e99d"
    sha256 cellar: :any,                 arm64_sequoia: "f4ec6ff0a4efd798c3534357f1b9ef94b8951ddbef051752f30972deafd2e99d"
    sha256 cellar: :any,                 arm64_sonoma:  "f4ec6ff0a4efd798c3534357f1b9ef94b8951ddbef051752f30972deafd2e99d"
    sha256 cellar: :any,                 sonoma:        "a92a3a12db4856f9d98a0adf7bb81b884c495f7f46bfa0263639cc6f23a0aba3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daf140daf601c0ef16ab5f2a560e87c685051bf1f59ece29b8bbb860759dad06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "61301f97d7d75b7cbb90e4a03f7ee88aa061c89554859b055df8a7fba4930567"
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