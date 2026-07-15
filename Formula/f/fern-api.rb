class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.70.0.tgz"
  sha256 "9e6a2855efb3638a8302f925a2e17c9da484c31ebe03c35b0490ca4139802381"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b18ca101b613f3fe34de1f557b742f563d8a0b26de4b5987dfafc2b0634f4096"
    sha256 cellar: :any,                 arm64_sequoia: "b18ca101b613f3fe34de1f557b742f563d8a0b26de4b5987dfafc2b0634f4096"
    sha256 cellar: :any,                 arm64_sonoma:  "b18ca101b613f3fe34de1f557b742f563d8a0b26de4b5987dfafc2b0634f4096"
    sha256 cellar: :any,                 sonoma:        "3f3ad74282baa121941421edc6814e01e9a1823cff75f92e49b6133b67b04e08"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dcd10b93e7c88ed3ab7e6637c52b5350795c4b5547b0fea875d7e371b6799d7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23f75c8ad9b61b1e68d12a3274e95628fe749260942281c9518766ea6b49a532"
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