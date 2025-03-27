class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.218.0.tgz"
  sha256 "8cd3801e38cc74743c31203b29fd839064f7a293cca2606e01b12dd21d228284"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49ad6bdb3cb5ed98dfc88008ab50ab0095bf688d16fa3f8a36ad44a0e43685a7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "30ffc442421c342c8343a0c0fd8ff2e3b21129b6f60ef87497901ff3952cfead"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4eb1ef553e41b3718886cc3913efac2dafbceff366683b437a805e54424193cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "a60b0c16e593c8f8a9cb96f59887c7a21aaa50fa41111e4561105583c91aa5f6"
    sha256 cellar: :any_skip_relocation, ventura:       "f05d21b7c1e08d5dd6562b98a009495ffff086c1f53599afee0e0c75b20174f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "382f8824682ac89b839cd4d417d4a1dcb29bfae0219958a2ad1f2b90122de888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6527e48e5ce7aad8bfc8ecd58328a39c1555107841fcf056aa50c9d1bc72662"
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