class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.158.0.tgz"
  sha256 "6dc4b4f559a942c02a5f731653a975701facbcafd63550329e0bd3ebfab5d5db"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "9f63dc3d936ce3759c71baa14d3de6af07180b34260221c2211b9a3dc4c910da"
    sha256 cellar: :any,                 arm64_tahoe:       "9f63dc3d936ce3759c71baa14d3de6af07180b34260221c2211b9a3dc4c910da"
    sha256 cellar: :any,                 arm64_sequoia:     "9f63dc3d936ce3759c71baa14d3de6af07180b34260221c2211b9a3dc4c910da"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5ad21d6939a5bfc7fb616350894690ab45e71277936e1b99e5687a594889f363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5aad6a19708b941e011d3c8980413053c6de1eb14dd9aece6ecf712fbd5608fc"
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