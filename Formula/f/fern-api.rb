class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.31.0.tgz"
  sha256 "77257cc618c361e379ce516e40cba10661d60f65df2b21fbf7d0d51526d90d35"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3c6651171511eaf41ff94dab136be4ac5278537348e02b6a30ea3ef0c80b837d"
    sha256 cellar: :any,                 arm64_sequoia: "ff535032635b945ad8d23f89ff985887e31e33eb0d94f2131cbf163e1f44c0d1"
    sha256 cellar: :any,                 arm64_sonoma:  "ff535032635b945ad8d23f89ff985887e31e33eb0d94f2131cbf163e1f44c0d1"
    sha256 cellar: :any,                 sonoma:        "f763af37fca318419eb4d1bfeac2928516ba6e5d8fe13bb50523f3f6f5e47df7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3cf10dd631a5aa040e6654aa1662599132c257ab2a9434fa8f8ae7b323bc14c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb3a3205d43fda46d09bc8a26672bf62af77d85976d8c72a3bf1c5b739da29fd"
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