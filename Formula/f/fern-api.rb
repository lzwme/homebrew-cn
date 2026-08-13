class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.95.0.tgz"
  sha256 "5dffcc1ed4c6f8448efde764380952797010802bf3d293396fa1c2ac3947736f"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2f05ffa1c04234eb869e5a575bf356294ca40f47c99148a3c9048c27563e85fa"
    sha256 cellar: :any,                 arm64_sequoia: "2f05ffa1c04234eb869e5a575bf356294ca40f47c99148a3c9048c27563e85fa"
    sha256 cellar: :any,                 arm64_sonoma:  "2f05ffa1c04234eb869e5a575bf356294ca40f47c99148a3c9048c27563e85fa"
    sha256 cellar: :any,                 sonoma:        "ba80f4b2dfa5f10cd04b78bbdad581cf8b199581657592a96ea4b2a7dc19b327"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "415e17832fa78283789c5862e01c2777b9098d8034a1c838f3ddd8a03a21d5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0aff1c4b6fc41c8b8a52a48337c9b2d9fb24c21424959d36710725e6d5e4847"
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