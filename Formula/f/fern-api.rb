class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.156.0.tgz"
  sha256 "59b47da95bae201bc9fbecec63b56fab196df50e4f2daf49b080737275bbc0d6"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "46b2b9dd388e2ac2f9ff74ea9ca5f8c4098548ec24c0738a9ea459136a810558"
    sha256 cellar: :any,                 arm64_tahoe:       "46b2b9dd388e2ac2f9ff74ea9ca5f8c4098548ec24c0738a9ea459136a810558"
    sha256 cellar: :any,                 arm64_sequoia:     "46b2b9dd388e2ac2f9ff74ea9ca5f8c4098548ec24c0738a9ea459136a810558"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "69bf2c1e12ac4b7705d23f531acf31c52e521ca0b8449a9f8bf0f66bbeda338e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "88c82b6abaec61126dc40e67ee8a8a8d5578cf281d5deced26bd01e0610e9d92"
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