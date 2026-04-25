class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.94.0.tgz"
  sha256 "b1e8fc504f971b7db244fb347e51f54a5738725bdccdbbde8c60668eb57ea770"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c386d6dd7cf2dae03b77225eff6bd96dfbd29d89e644f63f9cd3fe4a1a8ffbe2"
    sha256 cellar: :any,                 arm64_sequoia: "a112203bda8b878e6d7ac6a8038c6a8e479d1847b44c1de60e61d00227193479"
    sha256 cellar: :any,                 arm64_sonoma:  "a112203bda8b878e6d7ac6a8038c6a8e479d1847b44c1de60e61d00227193479"
    sha256 cellar: :any,                 sonoma:        "27401622d773f27febe0b1175fed5878bf4ceb63abcdd0c93ba83cec80c2b09f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78cdb269bc625da3bd07ed95e0448be72bdc77802ce5a52d4fdc6208fae1cd9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "55b9c211d7239f47a18cb4b3d3a029a4663c2358c86cc2212aafb8e815706d88"
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