class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.0.1.tgz"
  sha256 "eec537b3907fe55129647fce869669b70306948040bb53b41da9c5a049b15158"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "35c9e4dc992f3f681310f23ff92d36c5b805e1009a35f1a5bfa15b18fe8352b2"
    sha256 cellar: :any,                 arm64_sequoia: "5d1b5fde99b7350f59177258e06497dc88063bee72c049b86dfca7997ac90975"
    sha256 cellar: :any,                 arm64_sonoma:  "5d1b5fde99b7350f59177258e06497dc88063bee72c049b86dfca7997ac90975"
    sha256 cellar: :any,                 sonoma:        "d7e695fdf307c43acf8e9cf256f89499a9c2b0410c88a989b5c40f66e693a6d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1c0ed5107dd7505eb2e4badf65e9c301aefe1cdf4e7190a16e33a19ef5d19433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74c05287c28118cd2df1f0c0ae3b20da176cc1c3bccd9f0a3511874689531267"
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