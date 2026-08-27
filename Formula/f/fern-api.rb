class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-5.106.0.tgz"
  sha256 "91686f7ede55092b9f7cef4eac814a1b8e572a23690f6b223a90c8bab7277559"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "d3c90caa193fedfc015edd9a77ed6cfcb3304b7c7fdc9ac7c2d884195e741ced"
    sha256 cellar: :any,                 arm64_sequoia: "d3c90caa193fedfc015edd9a77ed6cfcb3304b7c7fdc9ac7c2d884195e741ced"
    sha256 cellar: :any,                 arm64_sonoma:  "d3c90caa193fedfc015edd9a77ed6cfcb3304b7c7fdc9ac7c2d884195e741ced"
    sha256 cellar: :any,                 sonoma:        "d73fc4a90f79035be20566971f780fde71af2d64c96b64e7fe848678eec1f715"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f46d0a30863661d05a42301bd5f0b7012f99914403c14fa03381540b437d0908"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef0027d87a638f3867b3f8f3f206c8e036aa9537951f3c6b3dd6bcd96de72f3c"
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