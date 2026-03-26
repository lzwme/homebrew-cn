class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.45.0.tgz"
  sha256 "a7f08b2574b32a8ff7c76ecb7a634fb7e62fbc33d827cf3418ecfe2a875d8922"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cdcfaefb822ae655ad0bfd57698b0d33633b833448df55ea55be880897aee8e6"
    sha256 cellar: :any,                 arm64_sequoia: "25d4e91f105db7596a46b43e57b7f9a8a1c467b1812c35b24533b7f9ab51035d"
    sha256 cellar: :any,                 arm64_sonoma:  "25d4e91f105db7596a46b43e57b7f9a8a1c467b1812c35b24533b7f9ab51035d"
    sha256 cellar: :any,                 sonoma:        "fe03fe61dd8df062353c857b3c687802415e657b8bd8320d8bef6d24f9886dcc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a0c0d98f50cbcfcb55dbf9a9a2b705c3abbb00e1b02a322c8d84545d221bc00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cb18eb27280ce8f8d6e04191ae36a632f39bcadc9569484090d42315aeb48dc"
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