require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.326.0.tgz"
  sha256 "35209ddeb1699f66cba3444df43f410384cbbff201df318889f710f52eca7790"
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
    sha256                               arm64_sonoma:   "d0ec2ff62760ad6a6f0f54a3f902764e65b41e5d171a0d7d482c1a7e87439e8d"
    sha256                               arm64_ventura:  "11fc13dcd08ffce0c67a43ae886cee37bdcc0cb685c32eb40d6bfa0b65cd698f"
    sha256                               arm64_monterey: "744d53af3f142c93ddfea6a0f17f4405884e3fa9a173f6325471d018dce76840"
    sha256                               sonoma:         "28ab5968d29b558c9e2badb71b30e3ae09cb2c37197f44d4aa4763ba97bea7d2"
    sha256                               ventura:        "71b8a95b57a6feff428b43a4fd34ba4a8ce7ec22f1275b6e027c125d4877a94e"
    sha256                               monterey:       "cb34b38851dba75e8d43b52ddd6d231796a3f929fb92d9a0e89bef65f9fd8c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf3fcf86e223862dc69cd6f3d333f4bb65094876b61b31d9d3bd9a7e5ff8453d"
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