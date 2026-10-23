class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.170.5.tgz"
  sha256 "321e4b3dded9a7deee7968b663a380531247fe7ec0de4dea36add642e2ba3894"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "e4bfc9a7275ca636f8c7c1df68a738d812625f23d145c7ee86dac8ed8474e056"
    sha256 cellar: :any,                 arm64_tahoe:       "e4bfc9a7275ca636f8c7c1df68a738d812625f23d145c7ee86dac8ed8474e056"
    sha256 cellar: :any,                 arm64_sequoia:     "e4bfc9a7275ca636f8c7c1df68a738d812625f23d145c7ee86dac8ed8474e056"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "02a896e62d07c356a38a20ef6d668ca2afa3501ba8b0854f92e7ae5f147d8d5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "daaa710bf53b59a90464d22e6d34b3667f3ff8766d75cf575747db16bc1f3d8e"
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