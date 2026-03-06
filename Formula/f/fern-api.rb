class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.4.5.tgz"
  sha256 "b840d6f0da7c1dba2ab583b4b6d713c13d08390fdeeab872eb7f46d863ce8170"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b63caed5bd2a769b8b04d01bce75c6b95228b62fd0aca16333f6d38bea1d5ffa"
    sha256 cellar: :any,                 arm64_sequoia: "42a832b20d41082fab3f190f99413649b0b1d64b32e2e6a32fb417f2c7c4051b"
    sha256 cellar: :any,                 arm64_sonoma:  "42a832b20d41082fab3f190f99413649b0b1d64b32e2e6a32fb417f2c7c4051b"
    sha256 cellar: :any,                 sonoma:        "28fc4b7cbf33f9d3bc2f82308b75fcd5327984c3a4117875f0486ea61bfc3910"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164e3a9215a7d497280be5c9f266795be40488ded330085a785530ae776f54f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12ade85d158581d3d32ab0ec12031f948c285eeca5fd756de5fe3d7afae78bab"
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