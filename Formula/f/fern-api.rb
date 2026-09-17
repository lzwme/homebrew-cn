class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.126.0.tgz"
  sha256 "f2dc327fbbfa6e5e2ff266ae1aa7e4ea9d3bbe50e91be6fd61e4d4c91ce003b2"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "62ac7d998ce61ca8233434e3d207a2aefca16b2bca09f441bb9871ad02f7683f"
    sha256 cellar: :any,                 arm64_tahoe:       "62ac7d998ce61ca8233434e3d207a2aefca16b2bca09f441bb9871ad02f7683f"
    sha256 cellar: :any,                 arm64_sequoia:     "62ac7d998ce61ca8233434e3d207a2aefca16b2bca09f441bb9871ad02f7683f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f05a21b69c1fe9d48fd9181c334602799968928b438b7e0f7a7579317d330a61"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "08341aa8a6fde98974e7f1d789ed402d248b8af248f19ff5cfed8f21cbab8134"
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