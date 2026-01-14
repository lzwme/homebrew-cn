class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.40.0.tgz"
  sha256 "82550e204423ccc17527888f9c307327566e9b70f208aec5f8e1f1bf39d3ea68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "277498eb1a35f5699be3b0b4245056624901850babac1697105915360c442c16"
    sha256 cellar: :any,                 arm64_sequoia: "fc8b27fc6f4c121850fc8671703c0b6a2e6a48697b158ddccc6b28f5b7beb92c"
    sha256 cellar: :any,                 arm64_sonoma:  "fc8b27fc6f4c121850fc8671703c0b6a2e6a48697b158ddccc6b28f5b7beb92c"
    sha256 cellar: :any,                 sonoma:        "bbb2e5584dc9d48a828a5958948b451c04395cb48dbfd0a98d756bdbddf77015"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "425fc262e5ed34fc34d5290f5f894bd5f24f41b53d36334cc6274aa24e0cea0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "761d5b4a49a5d75d7ae983d45dcb7c3de244ce6e933f7cb32569dbf51e0ab09a"
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