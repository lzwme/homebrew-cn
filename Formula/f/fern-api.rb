class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.19.0.tgz"
  sha256 "a6ff03b42ed384cd2574919981df26ead99797dfd64c56ae2b3a57f845e3f29a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab6377b4e6377e01707ec7b289d4e6067703b9e789ef2b36c38613d8f5fbc4eb"
    sha256 cellar: :any,                 arm64_sequoia: "d4acad04a0d5826e6a53d3c43800553788512f034020b77942af0541baed3b36"
    sha256 cellar: :any,                 arm64_sonoma:  "d4acad04a0d5826e6a53d3c43800553788512f034020b77942af0541baed3b36"
    sha256 cellar: :any,                 sonoma:        "a6f7229f14b49a04f24e857cd86cb2cd76eb070dca7dc59ff2c821a50dfe54de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b51ee93b3be5808138afe9f6120674cbd90f8e493b20eb58ea9666ecae265836"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f09a4cd7e4797768bd34ea72d3915b6f64422ed5e81992dff888caaea68e513d"
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