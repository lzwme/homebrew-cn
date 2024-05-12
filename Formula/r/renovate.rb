require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.356.0.tgz"
  sha256 "3a22954cc5c64cc027dff193683be27f3d5411c9436fea00cbbca366524473a7"
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
    sha256                               arm64_sonoma:   "214f5ca77b86d96f971eff6ac264860299aea27bda0adacb088ffa6046e47cee"
    sha256                               arm64_ventura:  "78c8c922fe8e7305dec365604afe3b4cb1e4a8966547b36bd391fac45638ee49"
    sha256                               arm64_monterey: "678051c84a70e575b2f2031f036b63f2025d3e0acbb6683854a477038f5d4766"
    sha256                               sonoma:         "d669c9badaca534d72d5b206aa933b1a5216fe10d9a4e98c0afcf9654fe9d0d5"
    sha256                               ventura:        "c53663b4943275900ac38b31a594115a096147c74e6bbb59902cf0ef93c62760"
    sha256                               monterey:       "7f141ce35e33f6937a910d799110babb23fffcdbd3d515919169efdec1554359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26d915f2db773cacd1c9b6ca337741704fcaffaafb0de3f9b0f54df897502271"
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