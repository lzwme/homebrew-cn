require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.370.0.tgz"
  sha256 "2741d9b9648a690a300236f65835b88dac068b9a66ee376bc5eacd6d7d0a016a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3d235737604a97bcba419de15e5fd7976a5d9e92ff63b7816f18bd133668a5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cded716876a388d27c1b5b1b198276d4f38f2bfb44795e8fd7931f9f99e00a62"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49c5a9bb46eba08a1a4a38d682c7321c66e4f5e5c196bf9ab1527f5d210c3e56"
    sha256                               sonoma:         "8263a4a5fe4e2c0ba29f99f7c21b8afa2dcdca51da3c8b8e14bd2b5ade011bc1"
    sha256                               ventura:        "234996511af2bba09dce7404e122a1acc65d70d377e19da63f35e78a23507d79"
    sha256                               monterey:       "5aaea0c7e4c546ef624f61d28dc3abbe4c7bb373337318bcad9c4106a94cd063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16ab04e8334a92c177ab76a0653c467e41a1e90bd0603f9b7880428050c5ef81"
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