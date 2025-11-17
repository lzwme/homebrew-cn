class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-1.2.0.tgz"
  sha256 "57395252f2414c0af5bb62daa456cbdf6f4288f92d1354604b4ab70a50a4cf44"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "887f69a778186a84ad057844012e49d58a85d024a7c099f87a2219b401c5ca91"
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