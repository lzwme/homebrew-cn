class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.89.0.tgz"
  sha256 "73d588318693aff3201793c05993a3be0f811e422295e1d5c0def7e21b5cc6e0"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "eac79effb6a4685a1cb565c859f5e458a0ed4634c63c27abf450ec7721bcc980"
    sha256 cellar: :any,                 arm64_sequoia: "5799e1faad5fbadac0a958d411aff1fae212ae6e7f4f445a1125ad05602ce89f"
    sha256 cellar: :any,                 arm64_sonoma:  "5799e1faad5fbadac0a958d411aff1fae212ae6e7f4f445a1125ad05602ce89f"
    sha256 cellar: :any,                 sonoma:        "e7d9c0c95d3cb891e61925bc7b5c814dd971c949c86003072ff60d21cda97701"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9bd33d0528009bb8461af5a48714e588fccac47315343ba0ebd38eeee9dc4f07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1c0a6ad76466f195db5affa32d98c13352dc37d181395d7ab4de69368875c4e"
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