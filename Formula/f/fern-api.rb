class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.49.0.tgz"
  sha256 "3fc88fafd0e4863298a87bba78bbf67d05bcad6559da21f22d8b676a214061f4"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "daf8eb23d1cf6b5b148fc082c5dcaea6165bcd14a3f08c7b5561ab6d0964ffd0"
    sha256 cellar: :any,                 arm64_sequoia: "59fcd79254a09cfe055fc96c956acc4a00f1be98e9bf36aea4e64042537c8edd"
    sha256 cellar: :any,                 arm64_sonoma:  "59fcd79254a09cfe055fc96c956acc4a00f1be98e9bf36aea4e64042537c8edd"
    sha256 cellar: :any,                 sonoma:        "9a5e344e3fc052054a6d8ce6610bcd4f276e6a7f5758e5e973c6374b2dc62fd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2e9d1f8626ade0e34d982aa78be6b5a1a14b53269fcae20b88e31971c9f7633b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1617e6e15147f7b414a2a399fceeff9d22b1fc9c6d6412e39e142725977aeb26"
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