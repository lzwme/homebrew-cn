class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.142.0.tgz"
  sha256 "76268a186c46b9bc581f85a4260c140b4683f58ed19dd497c3fd2920e90b2d3d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c762266a310f7f66c5150446efba2f5b6b17f49edefce41fe8c22ce9ac9a11f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7964ffad69f56e15a7237f1a1490ee0c9c455b8f5c024e55810a6e163f477c03"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f91304fb51fd3348e7def78514235db3a73eb70182e0f6ec9c3c86a2c6976729"
    sha256 cellar: :any_skip_relocation, sonoma:        "46351b945ccbff53659538fce47761dd21948f2fa4920ad0b168d480dbab5354"
    sha256 cellar: :any_skip_relocation, ventura:       "94c21f1e44c4babc3fa254cf90726aa5c986ff869c2f0829076d3629b157c005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d943a58a10e6e313c227befdeee848b550535486493c00cafa6532179b6b22f1"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end