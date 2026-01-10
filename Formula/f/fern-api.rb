class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.37.3.tgz"
  sha256 "8dd2f8a41bb98dadfe9118f2fd17c648ee623594e8da2fb94d46c0a8e17cba52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "aa1eb7fa2795f4b3fc4be099f8e6a54a3b6802b5c44cefa73141633e9565fbba"
    sha256 cellar: :any,                 arm64_sequoia: "b4174e1ecc9e4ae85b925b1079466d2e77505dfe729dccf88b65ad9ce786263a"
    sha256 cellar: :any,                 arm64_sonoma:  "b4174e1ecc9e4ae85b925b1079466d2e77505dfe729dccf88b65ad9ce786263a"
    sha256 cellar: :any,                 sonoma:        "de55f676fb64a295c1a145e7a9ae8e1e4e182947c8770643e0d2586d26c090ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "864244885696c72e2d33dc827a1be2a5c391b85ebf1a8b5aa9d6a66c22ef5785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b19c9559a23d13ad0b9e37524d776f34c1f412fc706e29bcab65464f3aa64011"
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