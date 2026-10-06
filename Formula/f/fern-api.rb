class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.145.0.tgz"
  sha256 "852235df5331e88756b6795e846b5c59abab80478048257b87c75ba4e45d34e1"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "ec9217a2fd10bb92a4cf3295d0f020aead99471f2655a2b77dbcdd71ecc30d73"
    sha256 cellar: :any,                 arm64_tahoe:       "ec9217a2fd10bb92a4cf3295d0f020aead99471f2655a2b77dbcdd71ecc30d73"
    sha256 cellar: :any,                 arm64_sequoia:     "ec9217a2fd10bb92a4cf3295d0f020aead99471f2655a2b77dbcdd71ecc30d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "16755cf257056b633d65e24f0a4bc599f67d24187ba84bf337e325f489351433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "29bd0379c4c55c76da2a1a1388e5e0cdc8e10583d673ad8b72b54caa941495a0"
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