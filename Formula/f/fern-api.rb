class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-2.17.2.tgz"
  sha256 "d815b016d128052a875edfae4fa1cb123f8775a6922ed799fafbe39fd6f0c6a6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ee758adf9c7a610960ccdcfdf999573870eb5331efa29ab77480b1ae5ccd8468"
    sha256 cellar: :any,                 arm64_sequoia: "b89e27a163f40ca3690e00513b63ada30e5bef9641e04bd04f76525cf0232b1e"
    sha256 cellar: :any,                 arm64_sonoma:  "b89e27a163f40ca3690e00513b63ada30e5bef9641e04bd04f76525cf0232b1e"
    sha256 cellar: :any,                 sonoma:        "8466f9fb975459c5c49236cd22621749979eca949c8c3201b0f0de3a639ac453"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5aa326c1fa5231536f2f1b439cad3e2d33e4ff4b4ce58590abeae55dda411065"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "651677ebe6f8106c6c54a51e79ae6264ae36b0efe1c580d396e98aa65cefbc14"
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