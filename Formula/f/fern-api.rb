class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-4.3.0.tgz"
  sha256 "dfe6a581775251061d0c469b49fc915761143498f2522b5877a0ca8c83d21cd0"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0fdb7719aca5033c4b11762d6d323024d8736c04b1fd7fb9430c75a25d665e1c"
    sha256 cellar: :any,                 arm64_sequoia: "4fd9944f723c81f298f640806e5d1b309830c4882a63987e48ef8bccf3291b1c"
    sha256 cellar: :any,                 arm64_sonoma:  "4fd9944f723c81f298f640806e5d1b309830c4882a63987e48ef8bccf3291b1c"
    sha256 cellar: :any,                 sonoma:        "da98f704b5b326e13dbb0925ffff1bc88b90a994716d1e2f4b0be53837ac107e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9c75e99b4dcec61afdd05de3a1b21c933f50333da68eb613efb2b53a7a04430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fdabaa40e65d5bfea7195eb5844884a92a63e8929f6977c4a75df260380c99f"
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