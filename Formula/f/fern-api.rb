class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.44.5.tgz"
  sha256 "ba1d499c8872f552a712ad5bbfda8708efd2ca05c12ff3c18052b5ea7fa5d668"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b9a142606f38a3e6e6f634a4d22ae26e1b5be0bac66059fcf4aa1e92af10412"
    sha256 cellar: :any,                 arm64_sequoia: "39b89f720b4ecfc9ad34d6ac9371a8d51783fa788666f1ea6dd9fb6185034160"
    sha256 cellar: :any,                 arm64_sonoma:  "39b89f720b4ecfc9ad34d6ac9371a8d51783fa788666f1ea6dd9fb6185034160"
    sha256 cellar: :any,                 sonoma:        "d65711b6d7a537d0fc912a69455c9e67dd9a2320dc0f30c6fedfbf0ac9123437"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bb9e833da94658f484763f8a55d47b6d27cfcaf47fa38fe267b10e279917ee7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7383f6b4bcd45c1e5a3c7a27881618c563a181067aae58d4a8046402dde94c7e"
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