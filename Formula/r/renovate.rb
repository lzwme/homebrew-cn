class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.162.0.tgz"
  sha256 "55ab926019d41344240f00a304bfe55fb39a78bb7c30b815edce246dada4524d"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3e0c694ef94eb5a9972a70365f8142689d00246ea4e07a6a937872810c6994e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb2b4574cc8fe4effe8124703c2398a98aa90b50018a204132e73aab34fbc307"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e068b164bc0e1277c8e6c5876f1057ca9ca36d44f44b22c5680071bcb989064a"
    sha256 cellar: :any_skip_relocation, sonoma:        "fe05592aef2a7a76f933a38903a9d1769f02c10e6e93b8895872ca69aec781b8"
    sha256 cellar: :any_skip_relocation, ventura:       "55c7826cc4bceffa75c6e7d0724dbb1dddd1e6849ae6cf9b90232bd25b58eb90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b21d25c2e31290a9aea9179a7770edb5a7af853965f8e1a2e61ba8d5e6d8e4d"
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