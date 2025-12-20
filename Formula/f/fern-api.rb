class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.29.1.tgz"
  sha256 "f107a70ae62d119f89294dfd1373523634c29ca5e1db015e07759d51aa828830"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2cb6eaa06172c60fe23a8096a0489b8653d01cb696103620afa0b66dd206f19c"
    sha256 cellar: :any,                 arm64_sequoia: "a0d879ff58e8bf28b16434c132a78e6a5133d4da328a9936a6fc077cca5b8830"
    sha256 cellar: :any,                 arm64_sonoma:  "a0d879ff58e8bf28b16434c132a78e6a5133d4da328a9936a6fc077cca5b8830"
    sha256 cellar: :any,                 sonoma:        "ef707c4686284000b5f3ddac97ce2f91246306b4828c16453ac6d0b942ac3260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "269fd15027a38913938f8a733cc13d38c0620a481df9c797b1077e5017f91b09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3f11e0431a328dcf9a8bad90190fb547b92842a12059fe6989be238130e2d0da"
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