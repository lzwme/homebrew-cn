class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.70.0.tgz"
  sha256 "fff0c90ace1537f35bba473ec32a14e6dce7d2c598a9eafa1761898d4a31c735"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3babe77243abcab020091304931505f381253dc361c9b15fc31ff064ce0bb51a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4d6a94c4a7773724e37b6dac1256c380055763c78650b6324ae58108c0d62df0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "27952f1a6e57469617f6fad683cce904c3be793b557553d75838f142a56ffcd2"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3504e44270ba701c2ac7e573c0e392d73eb1da0417172cf7b5d00d891b4f929"
    sha256 cellar: :any_skip_relocation, ventura:       "026b8fd04caec36a248f272f198f9e6910954e37f2835c4a83d111ec4f8acc2a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c55037551de813372cde36b341d3b4de9563b1c79b5f081011849e372a4adc7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56463d9adb74f87cc896ab3ecea8c964680508f6fc0d6d49f3687fe5dc6e6f41"
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