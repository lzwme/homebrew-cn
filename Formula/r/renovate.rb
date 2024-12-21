class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.79.0.tgz"
  sha256 "c2d3f39daa551825cd9272c14a7e3b3418aa6886bff701c9487de6aaded26ea7"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bc8e49109914886e69a5bd98d2feec1ab30cded8634cfb41e975e004bab2ecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8f57ab7878e072af2a0f088ed2f76143491badc14862c4bfe20d0c6910845de"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e58f18679e8b183fd68c12170cd31c6fb55201365ae5e7d9c20fff847a02e8f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "b20e83ba6c62ef9bb9937d5b4c40b694e899d16886dc6c6d827fb9e6f20839b9"
    sha256 cellar: :any_skip_relocation, ventura:       "d9828b32a678b123e4eef32356aafa1e52f3f1fa8c06038262f5f39576052caa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "aa07881c60f30a50140c9697f7c7ce62283b7f8a70f2dbd555f04527c730f724"
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