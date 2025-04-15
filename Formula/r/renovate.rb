class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.242.0.tgz"
  sha256 "2273e6612586fceab66ce210cbed4b6d75d72ebf862d796f030fe7881ee5783e"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00832fab40afb0e975f7f1cb0b3bb36bf68a5cc6ae48b11b8aa69212ac1c5956"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91fe1d14edab18a267b0e98e516c3b464cca7986a2b503bc4065e50385b3defa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a9f0c29bd094b8f19bb114c8b91e836ec904ef0afdb10e02396ef4256ec6c795"
    sha256 cellar: :any_skip_relocation, sonoma:        "c9c7921160ac150ee2e03cf582603c9ffe81046990186a2b6ea4529ead540af5"
    sha256 cellar: :any_skip_relocation, ventura:       "d66b39b1d2303aa72632b275f14d9d3de9bacd154a8328728d80c9f277f42c2e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b79122d764157f176906210544282418c8028709540a19c80bf8d0140c862fe4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d936ce9385b3bfe75d8cbbfae31704e24cd3d507a869b8f3ba2cdb3eb5d4d6e3"
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