class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.11.0.tgz"
  sha256 "e72c4ee71e939bc2b217b1395c0ce0677da03b7b276854cf5658f70176f95a19"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "98e2955f5112446e1f2a359c5f9a9d5e91200b1cd7ca76b396b5c0a0297d1def"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9279dca4cd0393db96aa1d39d23964fe2640b490773fbae62c9feec5b2edc559"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21a4296e639b1660c0fc7c7d2de7eada33d1d3585df4b1f5066e089e446ff5b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ffb311ca8ede4b3a6b205ec078b20959d9fc987f12ab528b227747c456a73ad"
    sha256 cellar: :any_skip_relocation, ventura:       "1e344dcbf044d00b41b37eefeedfd021e285bd344b8b2a3b5bb5d3e732b3321b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f38f43dc0c6d80e249a8ba67e448ca299c00100c6590fdcfa88b4bb92ebbb95c"
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