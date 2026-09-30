class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.143.0.tgz"
  sha256 "f3276707e9fbc05b6c60dd9fd02e5b3f2112dffeed83ed09cc68a817286fca35"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "c6e4c35a5282ce8d5f31b8f35e9da955a956a08112b4d304d8813089dbaba89a"
    sha256 cellar: :any,                 arm64_tahoe:       "c6e4c35a5282ce8d5f31b8f35e9da955a956a08112b4d304d8813089dbaba89a"
    sha256 cellar: :any,                 arm64_sequoia:     "c6e4c35a5282ce8d5f31b8f35e9da955a956a08112b4d304d8813089dbaba89a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "907028e6112aec34252bfc49281e021876737a0b8034e34b8fe3ec34f594b72f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ad9fb74eb72ba43f35a5b5285fcfafe2c9fad9aacb699f26197e030239d376bc"
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