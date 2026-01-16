class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.44.1.tgz"
  sha256 "7fb8bcdadcf5ca4d9e7537c9a9209534a9c7115fd3d055b7c8a6fc6315baaa76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8a04f61832f1a89f8a12bf3c108d9058d208c2249681954cc7f89be8e74ff2f4"
    sha256 cellar: :any,                 arm64_sequoia: "426caafa0ac549674019bcb576fd27b1f9c5e276597f997b40208585d483b989"
    sha256 cellar: :any,                 arm64_sonoma:  "426caafa0ac549674019bcb576fd27b1f9c5e276597f997b40208585d483b989"
    sha256 cellar: :any,                 sonoma:        "2cd0e75a9f19bb214a880e0ab95fe7e718271a88236183a94418fa8dc2418554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5a81eb10e11eff0ed13025b606bb0f6f5c92ab932c48fc7ddc5078c1318b6a2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "48dc443e0aafa5935c495f16dd4bf61d1e34668d87ee898c5e1508572036a0e1"
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