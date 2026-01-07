class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.35.1.tgz"
  sha256 "cfe00f204e70d7f448d5eaa35f758308863e9af8a885483f9ab914ab75684b51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7380b0fc4bd330424b0aa517509429b5aa7b9416624a53f4236655d123b7c3c3"
    sha256 cellar: :any,                 arm64_sequoia: "5b9e61ddcd92bdb3b3351ec941d2328ee242b955e8e62bcad22c9be9173c58b8"
    sha256 cellar: :any,                 arm64_sonoma:  "5b9e61ddcd92bdb3b3351ec941d2328ee242b955e8e62bcad22c9be9173c58b8"
    sha256 cellar: :any,                 sonoma:        "be66ee2cc5d6c15ed43376c3c3664b601777af5b7cbb6938fb3844a66157d420"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05502abbedc9d72393b8f3978b6e573bb07f03daee927955cbf0e962e4db3dd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "487afcb9b2c93e126c9d5a0db06284a940c520b0609e489b663e5cb93c81647f"
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