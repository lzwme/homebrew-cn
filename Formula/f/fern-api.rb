class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.110.0.tgz"
  sha256 "96cb589419b15061d7e5beedcc92f08da51d89532f731796ec9e3be14af1d398"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "61a92b4181fb514d3cd18610314e7289de07297da742bd5d1f4bdb6d037814f7"
    sha256 cellar: :any,                 arm64_sequoia: "61a92b4181fb514d3cd18610314e7289de07297da742bd5d1f4bdb6d037814f7"
    sha256 cellar: :any,                 arm64_sonoma:  "61a92b4181fb514d3cd18610314e7289de07297da742bd5d1f4bdb6d037814f7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c10f64f8a7dbc7572fc1c918451df466513b8fd7317124bcc818fcb87b2c6069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76ec7c917527d5dee7ef2e039cc036d57d7def6da5c785313b3d9179f427d1c5"
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