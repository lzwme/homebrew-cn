class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.90.0.tgz"
  sha256 "b0a28067c83604b5b5e9842f5d1d7e86cbbe7c61b3f7cb30704977ae4ada7bdb"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "82d8034e3763dcb7c0eeef20dad1a637dfaf831a443fe6aa0f02ecb4cc8a64b8"
    sha256 cellar: :any,                 arm64_sequoia: "ca71a19b089864d965512be63a6689d565375186c4ca2332e38e067a72a0580a"
    sha256 cellar: :any,                 arm64_sonoma:  "ca71a19b089864d965512be63a6689d565375186c4ca2332e38e067a72a0580a"
    sha256 cellar: :any,                 sonoma:        "1f86625ffca0184d649c2f57c919bd3aa6d2445a960c5ab30e1cdfba8a1a09f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3359278cab780a3eecb271c7c2e7a161f384296dc001534944c5e9b6b7c6609b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4198e301f149592ced3cd3ebfbc75308aa72f3e185670152e6714313197c127b"
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