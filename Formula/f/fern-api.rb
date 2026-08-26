class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.104.0.tgz"
  sha256 "887506329472dd266ec0c0908ad2b8a80b966dd8c32d9055638e57d9d58f5de2"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d3d7af1fbab60671a17a9ff89735561339edb71a8c9b1675aacc125fb84fa9c"
    sha256 cellar: :any,                 arm64_sequoia: "6d3d7af1fbab60671a17a9ff89735561339edb71a8c9b1675aacc125fb84fa9c"
    sha256 cellar: :any,                 arm64_sonoma:  "6d3d7af1fbab60671a17a9ff89735561339edb71a8c9b1675aacc125fb84fa9c"
    sha256 cellar: :any,                 sonoma:        "610a3ff5acdf8555e1d816d9148450ec8ac691c1e97cc2a60466e5174dbede5d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c904c4279babcc9002ae8e03f7050609346c6833e3098a33bd467265d7c32efb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f75858a0a7c0c06be3af000faab7813fd5614c1107af25d4124454701b4d01e"
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