class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-3.50.0.tgz"
  sha256 "0858f7818244886b83004c52d6d1b6ded6dad646e62cdb9741a813744a40b012"
  license "Apache-2.0"

  livecheck do
    throttle 5
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "94a1e4c8213fc4215145f32acb97339e36e7bc8c2b50e399ed244caff5b00b01"
    sha256 cellar: :any,                 arm64_sequoia: "37694c02c61af081222dcbb6a16c19e6833b9fc823ffdad346ce80950651587a"
    sha256 cellar: :any,                 arm64_sonoma:  "37694c02c61af081222dcbb6a16c19e6833b9fc823ffdad346ce80950651587a"
    sha256 cellar: :any,                 sonoma:        "3bfed703de04710b678e45e048041e28350b5248a448fc14b2dba0cccf28199e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a988ad6abbddd6e8455e161d41da94e0e3cad282f6af4c83004e7e08a0dc097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "188a176fada4f07a6dce35f40e0771531e2b8df80dfb4da27ecfc23c70ca1284"
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