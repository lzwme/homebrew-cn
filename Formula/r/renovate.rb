class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.230.0.tgz"
  sha256 "bf84db9076eabe7df286a0f70e19916005c739085c0bc3c371a6754755fe4550"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c0cbe4743756542c154daa7c67ebcbe511f77359877b2e027644890e0a7a73f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a2a98cc15459cfdd5a23e1a7e7fddf63a90a0d9aa35e0226391887491b9ddc54"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c2cdf1f6bbb157b4d97decea734ef897ef0e0e59e75b7d776f6133bbe2df8f7e"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd9b4dcb476831e37871f90f60cb82ef947367dc167d46ab93a58de682cc5d92"
    sha256 cellar: :any_skip_relocation, ventura:       "281df7c621f40f6e157b58293dac5c55a0747abf9136a2a8b218864b63ed96b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c821a3c00b2ad2571e684668d5f4459b36aae937438e2931c227121ac578673d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3de74a7aca5547d02da94071283c519ef708f453225cfbc637dabe295878c53"
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