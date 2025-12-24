class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.31.1.tgz"
  sha256 "2f08c7ceb54608be8f49243c646cd3f46f5c7bd296bdf663d852aed430b70e24"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e8f435024ca754f5729cb6ffece08bfb2ca8d294e3794754d419d9701468af69"
    sha256 cellar: :any,                 arm64_sequoia: "26c3b85a1681df5b2e709a4f9e98e7428661dbff9ee797bd8397f5a33d837b50"
    sha256 cellar: :any,                 arm64_sonoma:  "26c3b85a1681df5b2e709a4f9e98e7428661dbff9ee797bd8397f5a33d837b50"
    sha256 cellar: :any,                 sonoma:        "62f8e0b90aa3bb3b0669d43f576dc909c10d2e70429118dab075f2d37ac06c30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5f8993e2c25c6a4b2e6aef27ae60cebf4d16414c8db99fee31e7d869ac569ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4131681a40849a660b35dfee557d713636741ae60424c81ce28e27fb4c62ac8"
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