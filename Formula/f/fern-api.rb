class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.56.0.tgz"
  sha256 "0e2978a05d212e3dedd3a9b2e704c0298211ae4f871c11b6516891b768d4cd61"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "58d59e1cb6d4e3c4c00a6566fbe297011a7190a812ab50e4562d53d3f2942675"
    sha256 cellar: :any,                 arm64_sequoia: "50e77d02297ede022c99fd28f095872ee53e6c87dd52de0472764fe3e880f699"
    sha256 cellar: :any,                 arm64_sonoma:  "50e77d02297ede022c99fd28f095872ee53e6c87dd52de0472764fe3e880f699"
    sha256 cellar: :any,                 sonoma:        "7e2775a6e0cc709232caaaf4a9e78926bb7ed4709419c8e12d2add0fcb3aa8b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b0aa5e5dcc9d50f4e11efa2bcbf3e1fdfb6120b99027e9abd34aec0ffbf6faaf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e00dba93f2258e56616c077c42dc38d19a5e0d77f988509be3d13d7d0245e6d"
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