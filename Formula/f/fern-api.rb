class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.57.0.tgz"
  sha256 "2d0d1f66fc841bbd30ba8c7d295434ee4bcc9a3fd6a1c12713dba0b1c2fdd4fa"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0746c2be87777fc5b10f9faf80aada1b51c2efdc0d1d9fe331ec34606451740d"
    sha256 cellar: :any,                 arm64_sequoia: "d006244dcb2e266b492b74b463bad58cf5e83b12f7ea07f09056dd1feb284fec"
    sha256 cellar: :any,                 arm64_sonoma:  "d006244dcb2e266b492b74b463bad58cf5e83b12f7ea07f09056dd1feb284fec"
    sha256 cellar: :any,                 sonoma:        "8c605eebcfd3bf6eb55a0ab1f006538acce6c0c56eaf0cb8ce2217a211aa35b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48f51a74166877e13c15d31bc10e0dbd0c28a715bd7843f0ac0463632744440d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bddfb315e93a92d59709221d4dbf4896a2e8d1685ef724753ec13d92a56e7617"
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