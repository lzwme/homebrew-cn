class Jsrepo < Formula
  desc "Build and distribute your code"
  homepage "https://jsrepo.dev/"
  url "https://registry.npmjs.org/jsrepo/-/jsrepo-2.4.6.tgz"
  sha256 "e8996c9846ca54f8479c491509e1bd9b7b93846b2b7ef1d863fca6ff8dd54e90"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "5f858c5bd54ebdb889e75e201ca02bb273a1d7498d4f538fafc2f4bdc6d0e4e1"
    sha256 cellar: :any,                 arm64_sonoma:  "5f858c5bd54ebdb889e75e201ca02bb273a1d7498d4f538fafc2f4bdc6d0e4e1"
    sha256 cellar: :any,                 arm64_ventura: "5f858c5bd54ebdb889e75e201ca02bb273a1d7498d4f538fafc2f4bdc6d0e4e1"
    sha256 cellar: :any,                 sonoma:        "e5ee21da2f09a36f997f9a282d389b0561237ec3568bab28749a7b7397bff4be"
    sha256 cellar: :any,                 ventura:       "e5ee21da2f09a36f997f9a282d389b0561237ec3568bab28749a7b7397bff4be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17043015689115d76efe0d43d428570ded5fc082bd535c4c7ea32c6eb6d24da4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37843a1f2b8e9e12204ec88b2641403a6d730f2a053dfcac444b869050a5236e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jsrepo --version")

    system bin/"jsrepo", "build"
    assert_match "\"categories\": []", (testpath/"jsrepo-manifest.json").read
  end
end