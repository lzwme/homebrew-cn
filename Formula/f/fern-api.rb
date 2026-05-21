class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.35.0.tgz"
  sha256 "9720efa644df38fc3943ef48381a1688520e39ec562d4ebd022a12b5b63f2327"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6634ffe573cfd5bd7bb6e9887e55320c806ee922643d9c232f518f2878e47ef9"
    sha256 cellar: :any,                 arm64_sequoia: "2b6153a5fbc3e7b49a205463de01aa147bbde46ad01ebba733cdbe9fc4f7977a"
    sha256 cellar: :any,                 arm64_sonoma:  "2b6153a5fbc3e7b49a205463de01aa147bbde46ad01ebba733cdbe9fc4f7977a"
    sha256 cellar: :any,                 sonoma:        "a4c7f77ad64b0fb968d53f75efc89239405a594e88bb42ed0a5d2361ed1e6228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5f528191790df2ad3c3cbc95086a22a32229db47688c5a12b078994a0d31abcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47b552ff3ba0b8628f033f99e2a3417cd2f48631f0d10032a08a5595bf90abb3"
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