class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.106.0.tgz"
  sha256 "2709c9856d847ef5da618b51d417f8cd28641ce4fd8efa6f2db1d5335793ac63"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2f51b275fde71912b9b4db76f44809813aa9db3deeac8572a70f19e652281664"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e30e6de958bc863fc8d315c6676431e4ce2c7fe51c7e680a5d08f80cc3658ae5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "156494c0ebb8e5a9dbd0a5149924fdee58040cf084503c63b2b6fda85771e5ce"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c366d1f5fc8d2524a605779848decdad6e12f4533a29535c915efa15d9cb701"
    sha256 cellar: :any_skip_relocation, ventura:       "281739da618dcbb60de135af76ba245e514e414d3c410caa8177246f101a1ff3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd6ce38e6e308bf5f8297803333fcc9282ff79494d31dbd13897e8f3ee5f5baf"
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