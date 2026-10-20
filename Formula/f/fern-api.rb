class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.166.0.tgz"
  sha256 "b7d37ec7ade97f119495725e2a6cab4ad9e9ffe4e753408d84e711b70bdac8ff"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "ec8df6a59324f3998b7c8e3a34b6d1005aa7fdff0714202df52f7739fb3d4a4b"
    sha256 cellar: :any,                 arm64_tahoe:       "ec8df6a59324f3998b7c8e3a34b6d1005aa7fdff0714202df52f7739fb3d4a4b"
    sha256 cellar: :any,                 arm64_sequoia:     "ec8df6a59324f3998b7c8e3a34b6d1005aa7fdff0714202df52f7739fb3d4a4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "63d27cc0d0e154896ce7181e5fe3daef54b059fda22de62d57bf8970d0030915"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "225040eb5ac8ae951657e4b57d12c228f7d70b3f50b911badc3bd04e2d066b2a"
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