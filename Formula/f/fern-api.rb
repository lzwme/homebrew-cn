class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.27.0.tgz"
  sha256 "78f85419395262122ba6e970123ebebbdedd3d125e9f216a371dd8770e0cd291"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8d787b07d17e91304112bbf2546a51e88897054dba25bcf858d5360f721d35c7"
    sha256 cellar: :any,                 arm64_sequoia: "f73f8f13beceaec7fd34c34ce028bb0c7dfbf0c37c55e942bac71bc25c5d87cc"
    sha256 cellar: :any,                 arm64_sonoma:  "f73f8f13beceaec7fd34c34ce028bb0c7dfbf0c37c55e942bac71bc25c5d87cc"
    sha256 cellar: :any,                 sonoma:        "d22000e89cd1f4e48673ff87707f049edd936ae93342916eceb8e9da4b129dba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3a79811997da9e01a952421cb9d0efec748ee3d9b5ab8bcd83ad9f31218b8f9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8731d2c27ac34af40bdf93e7b3ec93286367ddc9c537e42799cd7f101ec8641"
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