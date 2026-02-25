class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.86.0.tgz"
  sha256 "9364b5ba7715b4925ffd8fed6b2237ef9fd2b59e3b79c18db31c9eabbcc3fc88"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "378ae900562b1609cafe2dd39dda0ba7c0637dc3728e6233104751b94c18e5d5"
    sha256 cellar: :any,                 arm64_sequoia: "acee879e1b5636321e450d3d8f8be2fda9abd09170a08b4bc4fa6d84d741b94d"
    sha256 cellar: :any,                 arm64_sonoma:  "acee879e1b5636321e450d3d8f8be2fda9abd09170a08b4bc4fa6d84d741b94d"
    sha256 cellar: :any,                 sonoma:        "6ae2d497027c044faac1d124d90e8bee3449664a774ddffc81ecb18f8e85aff4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acb6923c0b5a9fcf29f1690082b406c7aa5dfd2c4b5168023497cfa71ecdbcec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "989f40a78225139130c9310d0a6428913033b6dee2ed313c54a3854f938c7c4a"
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