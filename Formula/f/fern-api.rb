class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.38.0.tgz"
  sha256 "92dac2c2e7460525d85fff0625c7079a2cc3152465872faeae9892bb9b5e032c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7b1a789430eb8e6dbba325df20c9387764eea031c1f8238f688be7a5c7438736"
    sha256 cellar: :any,                 arm64_sequoia: "c7c0c0941fa87387150c965ce95340265c48c38759de969c5ef12fe76bf5c977"
    sha256 cellar: :any,                 arm64_sonoma:  "c7c0c0941fa87387150c965ce95340265c48c38759de969c5ef12fe76bf5c977"
    sha256 cellar: :any,                 sonoma:        "520e0ba38ce38d83a0ac8b30a924f0662eca5439e672b7d6aa7c112e03fb6ac1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07754c518fd044b2dd7fe87e0e30b951dd1606aab60c6c00f25fd634c6126a09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3c346f089f67ddccb80d655ca9ce6396ebc8e063a3ec709fde9500242e6db7d"
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