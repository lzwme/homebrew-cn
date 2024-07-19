require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.433.0.tgz"
  sha256 "c3c89385fcdc9a6d4270c2854cb9a45281c8be332231bf3dff991d818c8245f1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7b09942b6ff727116e125fb5a412277328e90bd62cd31521bec27e9b777f9965"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0bd57af6d9384977a49daca4a6edeeb5d133328cc23bb4218988bc427492afc1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "574a417262459faccf327942ff7751617ba30cd7b644f3f3b3aef2890ef189e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "f24fc3dda5e86e0e576ef90a553ed128f4ce3d764b3f2263aadceb1b9b569be7"
    sha256 cellar: :any_skip_relocation, ventura:        "b0959c3d20e1d5b71023d52849d3cb3e04282967253ebd62d8c0cdddbd3c30c4"
    sha256 cellar: :any_skip_relocation, monterey:       "359c4bfed7171248eb7b31d4420ac69458f1cc2819ac0233bea5b167845ae47f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60190f84df4f828a2fa422ea95d92fdde8b700906aaed632c605208cf1867973"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end