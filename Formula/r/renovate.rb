class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.194.0.tgz"
  sha256 "d81f6168480c4e05dda4d77f64ac249f2c92090240d5b05b93056b47e55141a6"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84dbd094837e280a1957989c42fea345541e65f9f3b215fa4e3a39e7ea305d69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "65c6165299fbd16c3cc9c1024fca0c7e04596a1813e273af7bb601f985722280"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6fc9e01958ac0c017d715733c5bf7917cbb5b20dddfa4dff85c9ce68539e15cc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0d874ae25444905237630d09f601abc2083b4472fcd68165ae2511b80b084f8"
    sha256 cellar: :any_skip_relocation, ventura:       "40fbbf7ad17e2b1935c267ed92448104667c0d59dbeebf91b860055d410c0485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f28a3e6d315f0c638ecc96870ea4451d20efb9043a0faf557a2ed089bc29d87"
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