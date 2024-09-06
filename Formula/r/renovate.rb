class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.68.0.tgz"
  sha256 "dc635935d1622719138fc0540a21dd0d17787b34075d674d733ee8803cfdb842"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f2a993e362e14813f77f5b2e47d9cf88d81f5996cc39d7867706f15ce48e6f48"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbdf67fc9c932baa842637fa577a9a70e1caaf00156b056e58925430af3e690e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ac7d218d727725ab69f7e6b5075d192240170352bc09a67e75451ba7854206b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4229a5e45308f058b1136bd2d786ea78874ea55f8a9c94fa5c240eb071678027"
    sha256 cellar: :any_skip_relocation, ventura:        "da581523f9874dbfb3700694a7f70e2d7ba3982043fa3f33938689ea0bc817d7"
    sha256 cellar: :any_skip_relocation, monterey:       "03c0dfe0531a993495ffcc8d5e740adc06fe625c5c0e1ea292837cfcc1718ca9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac7557d7d361e74953eb044e583068f95c09c32e0c917c23d3e5ab7848b501d0"
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