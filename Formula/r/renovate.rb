class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-41.17.0.tgz"
  sha256 "1681cd70452363ade8669f0e794c60486ef611b6c092631a9e0df3405d89f6d2"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bea75357da97d365f52047e62d16fef5e1dbe9068e44d2b72d6c9688dbdbd552"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c480b5c7fa951624b61d648f70fe137f527b2c9ea0f3eca2b1759b895da00696"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba2da565439a105e5ba6ebfba852da56bd1a0fc5890f10890ba249abdb1d0d0d"
    sha256 cellar: :any_skip_relocation, sonoma:        "54bdca378b845b46f039eb90e85e65adf4afb5d162df78c61adaba23b4075319"
    sha256 cellar: :any_skip_relocation, ventura:       "a9f4762abc4a4e81e909be632d5481bd0fc26b672d0044b6c6f72fecde72b422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9db0b9742ff7b40bbede5af2523dfd0ec663311e5aa67314544c567deea50457"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be7678200982487652d6094ab4938e1e99343efb6671ec0068bbfb1ab96c5de8"
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