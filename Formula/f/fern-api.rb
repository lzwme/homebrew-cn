class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.63.0.tgz"
  sha256 "5e0fd326751f12e15dbf97c30256b718c1ddbfb64c20f64035e9c2827588cf73"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f09e16573c8f4c6915403eb6e6107ae587db618177b700a6b5bcc8f8fc92db5c"
    sha256 cellar: :any,                 arm64_sequoia: "ed8c01fd4409d1f029beecd6aaa9c2cf0af9f30006ba208f763fd5b51dc7a1d9"
    sha256 cellar: :any,                 arm64_sonoma:  "ed8c01fd4409d1f029beecd6aaa9c2cf0af9f30006ba208f763fd5b51dc7a1d9"
    sha256 cellar: :any,                 sonoma:        "1d6f59aa1b6c8d12fd4bfa37fd0c7d5388457d258efc1e82e75bc7c141b4430c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab656dc1ebc5cb02673db90504baa127f27235ba986b9429cc530c44e448d15a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a01e44cde1896c0993ded63bb541d7102c6ed536dcbc37765332755570b2526f"
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