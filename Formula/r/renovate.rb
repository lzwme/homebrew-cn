require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.292.0.tgz"
  sha256 "4cdea3a803ffe53dff47e2f547c63657e777912c337e057bc90a79f9c1e4fc1c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c7d22d417fdd8ab2d803a51a3c7908d5b1865bae51e63110c04356a6824527e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7eec8e3403861e1035807d1ac1911e05738bd03f41b1dfb6e4a121e1a2c984b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7339be8080d0a4fba9c64af7395715f1cd8d99a6f08905366b04e50218024c10"
    sha256 cellar: :any_skip_relocation, sonoma:         "216af83003efda92334ff9e3da17bd44311927ff9391c344f1f70a406c4cf07a"
    sha256 cellar: :any_skip_relocation, ventura:        "4f0b9753ec1b2418d8b7dc7cd5ad85186d9fb37abb895519361aaf2879f1e740"
    sha256 cellar: :any_skip_relocation, monterey:       "cf5ae85e5be281ad81d446c8f619c095f52c8d60b054043ea9d0c8ea0825d177"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48e4daa49f5400075034b9ca64f1a39727d43d7e20ed86961a0c88da69588335"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end