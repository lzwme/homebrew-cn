class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.89.0.tgz"
  sha256 "889b717d41f60eebc1a368231c1900b468d2a3f87ac6882f2869718e36d17162"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "54ef9df5be1b2193b3f076d43d4a9614ffe3fbb127975557e24d78ea5993ced8"
    sha256 cellar: :any,                 arm64_sequoia: "54ef9df5be1b2193b3f076d43d4a9614ffe3fbb127975557e24d78ea5993ced8"
    sha256 cellar: :any,                 arm64_sonoma:  "54ef9df5be1b2193b3f076d43d4a9614ffe3fbb127975557e24d78ea5993ced8"
    sha256 cellar: :any,                 sonoma:        "116eccd15ea15f26f59ef8f7ff0ad5029114736e20334cf24a3bdea26b7dc87e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "159f7d500594db8f81efb8c1f9b045228cd7fbd9a4a414774ccb9c8d206263bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d8c0606d9765a1e4a716c09519378f05d64214bb9cd6dd315fd47d90039c760"
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