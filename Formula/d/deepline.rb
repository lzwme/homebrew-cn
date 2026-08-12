class Deepline < Formula
  desc "CLI for Deepline data enrichment and durable plays"
  homepage "https://code.deepline.com"
  url "https://registry.npmjs.org/deepline/-/deepline-0.2.40.tgz"
  sha256 "59ad8ceb3cef258f3962c88d89e701be8d30773a20e9aa6bd78c85e21ec0cd55"
  license "MIT"

  livecheck do
    throttle 20
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c863cf1d2a41b09097387e1b8ad6a00e84a9531b25239accf201921ceeac79bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c863cf1d2a41b09097387e1b8ad6a00e84a9531b25239accf201921ceeac79bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c863cf1d2a41b09097387e1b8ad6a00e84a9531b25239accf201921ceeac79bb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a353761362b9abc7963872a6af8dabab5d9bbb372b574415c4465723713a3f03"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fcea608967508617429016efddc1548c6c700285276a78401990f0c849925431"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d786dc66e625a084cf728bd543be7036dc6dc4e5c892dddb6abf2190cdf0c364"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match '"status": "not connected"',
      shell_output("#{bin}/deepline auth status --auth-scope folder")
  end
end