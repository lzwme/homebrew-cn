class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.119.0.tgz"
  sha256 "266db72884b04c659637bfc4f632e042c24e16830a486cb05d8fff93fec3652a"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eee46a6f9da324e7d920a1e654725d4c63e374f8d5f6d063c310294d46503429"
    sha256 cellar: :any,                 arm64_sequoia: "eee46a6f9da324e7d920a1e654725d4c63e374f8d5f6d063c310294d46503429"
    sha256 cellar: :any,                 arm64_sonoma:  "eee46a6f9da324e7d920a1e654725d4c63e374f8d5f6d063c310294d46503429"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba56e9b12d21c89557a4f0aaaaec86e7de490b94d43e6203cb105205a746f6e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "90dc7c0cfc33550101538831d8295edd6fef722314f077d2a53420a68c04aa10"
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