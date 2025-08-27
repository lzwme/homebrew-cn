class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.85.0.tgz"
  sha256 "857f6be57e202ed0e77f24b1c2252b0e50d3d70fcd317ce98de1c2fbec04054e"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7da49f5aa4fdab408e42fc4a1638b43a4de86f7496921789e63003b50653f838"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "76f6282a1e0227babc3e554c077f71a3819a890bb6ad298551d81753007ea73e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c7df9039f5694ccbed90a4ccf217516af0eab7ac5a156a6be381215dd65b2279"
    sha256 cellar: :any_skip_relocation, sonoma:        "d69a297cf3e0da80c4ce8cf2c429fd7ee6319bea49516d5940b9531a3910cd4e"
    sha256 cellar: :any_skip_relocation, ventura:       "2766fafbb11e32a338271dccb45cfca174bd5890d2a79b6ae37056d22585ef01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2124fc14eba3a6dfbbfb2f16864dfe6e7d07918eb3784c3a7e63f237bbffde2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffa7a61e30a2d0bcd225e2ce11bc7d1ae524c6eb75ed6a754af9594f4f2ca91e"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end