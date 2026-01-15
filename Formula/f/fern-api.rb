class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.42.1.tgz"
  sha256 "e7d6e79e9a5093832fc97868056033f5ede3096b65829c541df50cb00903487a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "12b2669b27b6bf4bcf03b05fdc3f524aaf9c0666ff5db8613bfa7831a866d4e1"
    sha256 cellar: :any,                 arm64_sequoia: "fb379c8016ed9639ca7077e11f35f0674977811d0f509e3eea9f718c6ce3d392"
    sha256 cellar: :any,                 arm64_sonoma:  "fb379c8016ed9639ca7077e11f35f0674977811d0f509e3eea9f718c6ce3d392"
    sha256 cellar: :any,                 sonoma:        "b37cefbd09c2d4554ef447097d84d2efbc623edd6e84e58c0541485693f5fcfe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0c95818a26aabd25caa1855fba0990f4e98996f958a9f12eeeb9f3d43be87730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d01a2445e1ccd50dd87a44f2ead53eeb3efb6ee47f07109512439f4baca12db"
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