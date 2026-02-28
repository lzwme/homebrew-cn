class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.91.0.tgz"
  sha256 "37eb07357b2ab4a4176f938cedd7f61ad63e76b9091c50d17bee6209cd5f3e42"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bccc427027d05f0599803e766fcdec6f4b785c461f2006c7284ac13737cca912"
    sha256 cellar: :any,                 arm64_sequoia: "d41ec9298cd2d773d1ce1264f5243c7269b80660636f76a7e7d9374d808274b4"
    sha256 cellar: :any,                 arm64_sonoma:  "d41ec9298cd2d773d1ce1264f5243c7269b80660636f76a7e7d9374d808274b4"
    sha256 cellar: :any,                 sonoma:        "4b3dff01bd3e2bcb91521fbf88b361cbff6f07e95a5481944343173423c09d73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ed78d6e60c66466caeeb796612d6a75e8ad3e3bb5b1d3644079c2a2bf2d8c0be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df3e0cd682939224cd888fa86646b50634eeec9a3053e2ea87acdef9635d575a"
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