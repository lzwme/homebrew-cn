class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.4.5.tgz"
  sha256 "7ea192d8712670380968e39367d2dbe55fb3907a4ccdf1f6cc206bff5f4f72ad"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16402601e60a2f96164020b1c7d237047e9d3d64594d8e4fe051c2ccb37e0513"
    sha256 cellar: :any,                 arm64_sequoia: "03d6a4284e621f00835394e20d0e1b414cd7eb8595a80c4badf7f4014d5dd162"
    sha256 cellar: :any,                 arm64_sonoma:  "03d6a4284e621f00835394e20d0e1b414cd7eb8595a80c4badf7f4014d5dd162"
    sha256 cellar: :any,                 sonoma:        "c5a213215eee03babbab17162c199748b5ac3f6f4ede8f980722d30d05ae61a3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7724059a100474d8fb0cecc39dc379e76cdbf9e67f819b2cff9cb4868e73134a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cc97e121ee074475e9032f9a35e2e3c418400fa5c5d5ca96e0b2c0cfa776565"
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