class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.176.0.tgz"
  sha256 "e5c628247dc784a60e699c8486d9d19b573b90b1f78ee9eb18452450ab7ef191"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c9510c5b6f2fed6d12c205512db63505fbd1251fe031f2fece4143eeb29b61d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec822517c50362c0e7f0d07dadbf0542bd05ac3c7d2866c6f9caa8e41e7aeacb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca82fba277d891ded3e285a61cfa59b512919ad7d19a2bf79f8b41d0337782d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e5cc9164f1c7dcf7b9c1d53334ea2c10429863f0f1ec62c60fa0b46d23c7be9"
    sha256 cellar: :any_skip_relocation, ventura:       "f9201f801fa530ca39fe74e63a61b44b0aebd9caf7614d59ede27746bd944490"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aaef7e6765e4af9801540905bbb6d24f555937dc02dc8a724f84f74d809e5c2d"
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