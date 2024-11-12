class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.10.0.tgz"
  sha256 "3b32047f017f46a2f45301da27c8d5b5484108905ec7d906828bbcb288cfea9a"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d92a1587f51d57ba10f90b74f6f8f7f3350e099fdd5780f16e995d0b7f5d1dc6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32bac4065c3071b4e22c4c438a8a6af873c415e8ccda8fdf6a1ef12653d8d010"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "83ebb3a3ad03b9d9e1c8e41ae607720e44f90c3d58f086937122fa62169d3921"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1cf78ccb233f137a77929c044abb339c116d1ab28ddb91831589d65be6dbbb4"
    sha256 cellar: :any_skip_relocation, ventura:       "71bd535913db007d50dbebd4ffc96db0bd719e47a1c1335f3054f2ecddfc595c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b629d5187c3b251e0634a0c508905a14d5309dcd55e87ec81642d84a7a4f402"
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