class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.139.0.tgz"
  sha256 "590521361e837321ec87aef6595d1f594a1f5249437b94c1082c4fedad3c7de6"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "47ee1a6e97eac26be1a85de9ae4416ec9728d113d47d7f870dd9809749d2f371"
    sha256 cellar: :any,                 arm64_tahoe:       "47ee1a6e97eac26be1a85de9ae4416ec9728d113d47d7f870dd9809749d2f371"
    sha256 cellar: :any,                 arm64_sequoia:     "47ee1a6e97eac26be1a85de9ae4416ec9728d113d47d7f870dd9809749d2f371"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6a07096bbd85f158ddb03e5bcf474001574d92417749fa843690f1186c6adfb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "72b56a23b4e1b2fc4e4b6d4788674a7da0f6cfc19553d9b838f760aa9c4b4f64"
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