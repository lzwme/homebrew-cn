require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-37.14.0.tgz"
  sha256 "a670b9fe0eceddeade22f773ede69978b75fea2c12d77016fff24b975d651b0d"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2dcc0eaaccec639e3b1df8b7847fcacf99ce0870785c828a0433d6da4bff8fcc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b162c81e63129bcd06fffc4ec7c9a6cf6350f87ecb88fe0519f4b13cd5957acb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c62506df1c9ef57dca2dc5b7072f8b69c23f70cb6256bfd7faa88d3137a7ea1"
    sha256 cellar: :any_skip_relocation, sonoma:         "09731525925c941738cfbde44a1e4cc28584e80e897408bdf7b2a409e78eb032"
    sha256 cellar: :any_skip_relocation, ventura:        "703c9131522470f04544de169a1a39c95e68755578714963ededdb1e6f761239"
    sha256 cellar: :any_skip_relocation, monterey:       "81005c3959984a6b1f76b6c4ac8ba24803987ff0d9a32c2cef2e40fe976b96ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "134e59f2d2a6cc6bbef1dff3accd4b8c17e5fb514683cb6e040d37ecdf11dde6"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end