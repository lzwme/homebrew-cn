require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.325.0.tgz"
  sha256 "19c34267029943a93d4f6394d67ec10c965124587b03da17407c323a12235a62"
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
    sha256                               arm64_sonoma:   "a9df7c0cf5b7f1f6114d3c27cbafaee2ca0a684ab6decc7cc8761c5c32f35eb6"
    sha256                               arm64_ventura:  "eb40fc1050451bbcc409a8ad095b210c65bb42780f2bfe52c0700af5723dcd0a"
    sha256                               arm64_monterey: "e3bb342b992d4db5ea4b88b911f5677e1081c851fa8e420d2a879d6127a534e7"
    sha256                               sonoma:         "29793ac5951d582df63ee521884aa981227f30d2f24f51592c9db1d40f1c7478"
    sha256                               ventura:        "6c6c129e16755dca86207cbda42d025a72deeab689e4a9552c6a7acb7f08fccf"
    sha256                               monterey:       "3a7e65e80eee9e0c8d9e4f400b80c0d25fb6d92c6cc25b32d675bc6c0a83ea7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "595fbf5cb005559e92e983953ffa4fb200ef09d37b65dacbcd2f9aa0a5b12127"
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