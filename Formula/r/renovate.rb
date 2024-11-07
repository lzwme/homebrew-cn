class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.7.0.tgz"
  sha256 "a0073d15f68316fe9dae34787fa1f961a99585d15d289b609676466c03972960"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9855320ba9a27b61b16540e2f722772c11174a3fcfb09e0d22cb34316ce1b67"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a891b950c43578abfddced062b10cbca57844294edf5d94bb5c75aad5f610a1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20aa04952a4dae53ab0d77e67d38e6d7d562728fe3cec3b7f985b41cc0c1e36d"
    sha256 cellar: :any_skip_relocation, sonoma:        "10649e5b7811a1ea213f472ef383124aa95aef43009b5d17f48610d5bb59ff43"
    sha256 cellar: :any_skip_relocation, ventura:       "458043c75a8fe9ef77be0d0ae324dd7bbdba19ff924ce4865a3146c0766957bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d91f7231c893a200be9bead3bad3726d7113115528a78788290db4fdd3b697f1"
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