class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.4.2.tgz"
  sha256 "45b4922358b2dd4699d79cbc346a2a4a89e834aaf00e5593606fd66befb953b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bba6b6a33ff206a2609dc28d2e50546c7027521207ca88f2d882a1dcdc417eb3"
    sha256 cellar: :any,                 arm64_sequoia: "b1e514fc07e05d4c7281dffb16dbf5bac35c5e4aa6b32a893c3c49ba9ad0f56e"
    sha256 cellar: :any,                 arm64_sonoma:  "b1e514fc07e05d4c7281dffb16dbf5bac35c5e4aa6b32a893c3c49ba9ad0f56e"
    sha256 cellar: :any,                 sonoma:        "e672051319065621b43328ba6d3fe99fbede67b9b41a38488946591e61cd7277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cff94c8c06cdad89c0565aa02b6eb7fa17c3726a16054a49719d0ba5fa0afa51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e60b8996f980e3f69f001736080c0c2d0ce026d18ce13fb1320a7eec9b53b3b"
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