class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.86.0.tgz"
  sha256 "a2b0c6c69496cf2ce2b6bb8c3653496440596d64b38b472d5d76daccb156dfb8"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ed3f029e9c5f7d4dd5013f16db64d80122b5bf3eebd9520222c8efe1ff165ad7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a5b9bc01db230217bc89f74abb2ab99905fd5712ea562d065e8952bfdcb3cdc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "665f05aa9240026321788f108fa3e5149725242af9139dad774b6496b151eb9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa65517ea6336000a81b057f4f8a6317455ab6d9d9d28946f5f5b4ec1db504e5"
    sha256 cellar: :any_skip_relocation, ventura:       "4d3f6ab0ee3bc67b5f1375c3f87b875de1ca9869dc6fadd51dc53a13288899b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e3bc4e6c0c803ade0a1acd303b386708714edcc30370a0b4f87727975d4f3551"
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