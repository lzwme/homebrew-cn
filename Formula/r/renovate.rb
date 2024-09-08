class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.72.0.tgz"
  sha256 "96d2d7bae98ea4186a66d0e17c794acf27188ce99eabe5c9343803ec4a618876"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1fd336f1298e0db369e2fe63bd9959ff15fdd71ff31e410c60d3ebeb1a34766c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30a33ae2474eb0139c00be8ec1b82959ec73a6ba1abc8b48b8a5bce7b98ccfc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1d376cca30dccabeec1b2deee09d222af04e4dc214fa9c2d54f6c54dadfc1356"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cb48cfdd8f8c26d48826d56845a27b147e8c67b4b4a196f1094db0694a0c8e2"
    sha256 cellar: :any_skip_relocation, ventura:        "ab8889cda80e97f5b2816867cb2276fcbdc51f8ce14425b334fc77298a39af51"
    sha256 cellar: :any_skip_relocation, monterey:       "93f874aa737ef36f345426b7b5333e1f2deb5322159a96150c9dd0b38bc2bbe9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce5cce75290b426e734e6630d6cfa9815ad819ea1f33d90a7403bb06f263fec3"
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