class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.97.0.tgz"
  sha256 "52ec133cd1e684aaafc9726d7400055e998ef8f347ad237db94b2166016691d9"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "683bcf7401c3d5bd46311e1abf4bd8e08c20c15c5fad2175bf2e32e23d2bd083"
    sha256 cellar: :any,                 arm64_sequoia: "683bcf7401c3d5bd46311e1abf4bd8e08c20c15c5fad2175bf2e32e23d2bd083"
    sha256 cellar: :any,                 arm64_sonoma:  "683bcf7401c3d5bd46311e1abf4bd8e08c20c15c5fad2175bf2e32e23d2bd083"
    sha256 cellar: :any,                 sonoma:        "f848ebd05ed4c4bb8fea6a059d6911a91144249584fb938fd7f342985eb36213"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4583192d3ca96d0da304ac303afff4407d670a2997975f875b507d262c18d003"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e96a504dc44d015ac6f45313866e6e3c18fde8d5c54636aa6047f095aa1ce372"
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