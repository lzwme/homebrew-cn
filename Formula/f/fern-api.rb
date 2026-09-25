class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.137.0.tgz"
  sha256 "974985ffc15ea0e1143ccf90151a37100a3831494f893689000c0338b6b5d2e5"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "bcb002cc09ca76f92f914b18d3b984ae7607003b1d375ade8c70935af6d4153f"
    sha256 cellar: :any,                 arm64_tahoe:       "bcb002cc09ca76f92f914b18d3b984ae7607003b1d375ade8c70935af6d4153f"
    sha256 cellar: :any,                 arm64_sequoia:     "bcb002cc09ca76f92f914b18d3b984ae7607003b1d375ade8c70935af6d4153f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "77fc8ee8101bfd090b2a609f9d58da7847dbd629b327fd493682ecaf5c122481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "c451babb567aac5042a695697d019721d23c1923bdb4aee536caa5372eab09dc"
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