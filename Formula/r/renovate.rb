class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-40.11.0.tgz"
  sha256 "b7a2e8b0298d49f501ff22c6abe50b51bc72522a666b38b777c07e0b5de38216"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca7dbf8850d5d99cf30244eb9a3005c80fb42f92515b45a24b6c2411ccf2f5b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6885a91e9d46dd5647578e041330b2fc5f6a7c289b2a373a490608759dd5284d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "279a32df2732329a6280220d3be3c7efbfc222de5416303c2f0d5a8793e2c11a"
    sha256 cellar: :any_skip_relocation, sonoma:        "0aa8c252b9ba207badf4e11f0edc8d8f4c2ef27c7fd4711c738cc30dbb242e35"
    sha256 cellar: :any_skip_relocation, ventura:       "ae4ef6f3a0b5dab77a6e75e4c9129369801c25e88ba5fba3d80ae7985b7614e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d523c967216d6954d7e4198e3e134c5512542033c227818410face56187ccc35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76a2f82113f66a86b8775297ed350e950d459711532db821f1cc419a3fb4d7f5"
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