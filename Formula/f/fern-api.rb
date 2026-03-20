class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.37.5.tgz"
  sha256 "7dafe8bbe6d500cd02bf64ee13075d1b29717613b208a70134541fd56c97eee6"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a981dc097a21e8e93da726eb429263729d5e7fa63e5d8569052ac3c9b0d21bb0"
    sha256 cellar: :any,                 arm64_sequoia: "c28fa2b7130eca37bb1c2e4f524abbde0f9fe3a809b20878f04086ea51d3b0d3"
    sha256 cellar: :any,                 arm64_sonoma:  "c28fa2b7130eca37bb1c2e4f524abbde0f9fe3a809b20878f04086ea51d3b0d3"
    sha256 cellar: :any,                 sonoma:        "7c26cf88c24cb42ed3e7833a47bee9bfe6e3878e729e0862bfd50a5c7b5caa45"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7999579056447f8d0d68beb279c6b2f7760f2e43293095d475be3c178d91fce0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1546aab5777f510a17f184b07f966e54150f2a69b852f5d5d91a8543d46146"
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