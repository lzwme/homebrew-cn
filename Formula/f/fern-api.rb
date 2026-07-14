class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.69.0.tgz"
  sha256 "271aae9557d1ca81e1239c32d34978b7bc4f8f4edda48f7af40a9c3bed047b2d"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80e521460f6bc036b23b6bd581a7ce2dc266127b6ed3ec539d0b6c9f698d6f92"
    sha256 cellar: :any,                 arm64_sequoia: "191b334db7f5ef8dff1d05dbb166671faf0e6bbb8d72858a855e22736d339986"
    sha256 cellar: :any,                 arm64_sonoma:  "191b334db7f5ef8dff1d05dbb166671faf0e6bbb8d72858a855e22736d339986"
    sha256 cellar: :any,                 sonoma:        "69649156167fb86bae4dd11e7cee0f246eda8628ee29937fe08e2fd608069938"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "09da0d1b6dc2ee8ecf6983a676244a4d823839c1d6da944e138c59f21e625d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dace4e4e54166c4104997e6ccd56deb59869e37df18a119d0a9ac30c4b425482"
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