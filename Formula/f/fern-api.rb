class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.36.0.tgz"
  sha256 "29a40c881c7f4ba36e5d2503f2ac81c0a08f05b0d666f408bd3e34425c1d7720"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5481a8fe0da72e3e3a77cbd1129aeaee4661af5e311d05dffe60914663ae2582"
    sha256 cellar: :any,                 arm64_sequoia: "85a5a0029a803c7ddead2016c70ef8282484eecf1b460b5de5d6afe221b1fde4"
    sha256 cellar: :any,                 arm64_sonoma:  "85a5a0029a803c7ddead2016c70ef8282484eecf1b460b5de5d6afe221b1fde4"
    sha256 cellar: :any,                 sonoma:        "5898a928ace58305614d2be387b6c40821dbdc68e867cbd3476da9eef952bf35"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "739a336da24439270ec16e9d7a1f2a3a29f53af5a0faeb0fd297fc656c4174bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c6d71ebe096fcb88b55b5f18ce1850fdaf0e793162d897690cd26984336a0aa"
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