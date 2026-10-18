class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.162.0.tgz"
  sha256 "e7f964ec43ad5ab9bff7b54f301998b5a8d2ca89a26d33dd29429f7c12211066"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "db2f6e83d34b41c40d33bbf9499e0a9f008443c6a7f46e9bf58e4c56feec674a"
    sha256 cellar: :any,                 arm64_tahoe:       "db2f6e83d34b41c40d33bbf9499e0a9f008443c6a7f46e9bf58e4c56feec674a"
    sha256 cellar: :any,                 arm64_sequoia:     "db2f6e83d34b41c40d33bbf9499e0a9f008443c6a7f46e9bf58e4c56feec674a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "035d589375825787f48461f301fb7e97c0fdfd14c121fa16005024fb4390f5ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "e64822b06e31a2f4717d00edadc79cac47096aa72494399bd221ff34567dd8c4"
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