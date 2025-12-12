class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.11.0.tgz"
  sha256 "8801be3d94f8e9819d2abce7a4878be27bb211bdb7627a422a4aeb12bfa17a94"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2cc271964007ce01c708816c559a1d2c59ce27add8c43a824ce23cebfeec5857"
    sha256 cellar: :any,                 arm64_sequoia: "51aed9e2f62e7f4f1d72fe1f2496875b3f11f2c2582aa298b06b968fa2ff1261"
    sha256 cellar: :any,                 arm64_sonoma:  "51aed9e2f62e7f4f1d72fe1f2496875b3f11f2c2582aa298b06b968fa2ff1261"
    sha256 cellar: :any,                 sonoma:        "406b750cbae0f86263c39197d440b3367c5db11a06f2ab16f06eab447ff46702"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fd91350005198efeb14cf89285f9a08145643c8cc1764f15a2933822f2436fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "edbb5c85b216f928e3a4c0bbb41c6c2b4241c65a615554fa0a55c341ed54f211"
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