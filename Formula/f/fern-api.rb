class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.149.0.tgz"
  sha256 "9fd0f5a47d43ba3abc03576d23bac73cd2d16d03db67704ce5d3f7a0d1fe2571"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "88418e2149fac7861ef8e6891444e50485b4e37fd8f4cca4f62df18a57a14353"
    sha256 cellar: :any,                 arm64_tahoe:       "88418e2149fac7861ef8e6891444e50485b4e37fd8f4cca4f62df18a57a14353"
    sha256 cellar: :any,                 arm64_sequoia:     "88418e2149fac7861ef8e6891444e50485b4e37fd8f4cca4f62df18a57a14353"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0812cee870fcd9134e778feb131313909fcb6d0fa2ce01d1a081c97ca9198f48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "2fd46852e67e8fe7783cc7cd64ca70d66711e582d5353c1948cf9d9f35a62a1b"
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