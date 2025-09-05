class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-41.97.0.tgz"
  sha256 "8770558535a9e6c2a3c095dfbedde5c8f146d56634c843bf1761c24e61dbe246"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and the page the `Npm`
  # strategy checks is several MB in size and can time out before the request
  # resolves. This checks the first page of tags on GitHub (to minimize data
  # transfer).
  livecheck do
    url "https://github.com/renovatebot/renovate/tags"
    regex(%r{href=["']?[^"' >]*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
    throttle 10
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dbc4dd13d297934be090d15689ff97aba807bef654ab865ff9b567e8c64267c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0708dfa35fa48efbaef303b9946eeef13521012da5ca5babb12922fdff93f362"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b2d41106c0d45af5569f7812564b22abda2e2f63f4a1f0bd264d82d2cec2f2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3fe3a42e99bc2cb3f398082678f050d0f6c93994717073269e64b24754be993"
    sha256 cellar: :any_skip_relocation, ventura:       "97592dcb4ca9c4df2010fd08b2de08b6d32110f9b505392adf0b8188c974fefc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7eb67ac8cca7af2d55c012ced9756074212566bf1a3ac3e9eecd86dbeb42bf5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70b5be890c049ddfae0773155c4a760794c99f8cf652a85eeca0398825b40f05"
  end

  depends_on "node@22"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"renovate", "--platform=local", "--enabled=false"
  end
end