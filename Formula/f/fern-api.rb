class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.68.0.tgz"
  sha256 "8e472cf35cfce1d361012539bfa6bb3dfe3e4e8cc52bd4087d3352358f2023fb"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2668158d33110553a2fd031392204e6dd871eed6a8a6c92873f07ac9b9125f28"
    sha256 cellar: :any,                 arm64_sequoia: "244a55b9b47a166bb227adb587b540860250351ae9e774ddde8ce6977b361449"
    sha256 cellar: :any,                 arm64_sonoma:  "244a55b9b47a166bb227adb587b540860250351ae9e774ddde8ce6977b361449"
    sha256 cellar: :any,                 sonoma:        "0fe44e29fb19717e86c5f44f359657a4c6e74654a30174d4eefeb5033924df58"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f868fde4e8892b286cc5f7cec23545d2d7d08c7f310b9c40a56bd0e675860c0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0068ec00a2977d64ed561d6dd2860022d5b4fa6078988453a73e7e636e2207b8"
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