class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.94.0.tgz"
  sha256 "05d1620ece4f0c6978554539c5ff3754276d875b45e36208cc97dd8c08e34176"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https:github.comrenovatebotrenovatetags"
    regex(%r{href=["']?[^"' >]*?tagv?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ea83577539e2a505e96672aca3f9f28c244187c784a8e63c07cd6689e6f7cd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c26b9c0259a31afe8f83a2592e9bfb239ed9825f536463d479da72767f672a42"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "850b03113ea2ccb353997a47eb3857c7d04e6c51b1b6634b23cbca4c1622faeb"
    sha256 cellar: :any_skip_relocation, sonoma:        "2fd30d58ff1c205172b12e20f254e2f1161d86e4db309bf3e322bee0002b6c93"
    sha256 cellar: :any_skip_relocation, ventura:       "279ee469d02775a1159e9ca296b2147ca256bda2e096885ca21e56c38561ddec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83adea930cd78f2403442727f1ca9c786fc3c44b9e8313ca8362ddffd2d32fdf"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end