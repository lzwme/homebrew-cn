require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.429.0.tgz"
  sha256 "dd5c9080535d1ed500a98b42bbd6842ba988ef6189c4e5f92f21ffe816576024"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccc72301da8cb6bd14bd2f92e7ecac5b8f0748638dfaa66cb1dcfe7c1b3dd3ee"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09841f3e7f82e31c3dc27c1658b83f87992ea7880d1e40ef9fdaa01a51fa0e01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4caaf27cb83918dd7c97ea679a731d5fc14674ba5d5fb9ce229bf901ecb912ef"
    sha256 cellar: :any_skip_relocation, sonoma:         "81b73735deecce3797e5c449a0f7ee8f366cfc6ea5771e3de8d1ea0fcd7dfeb0"
    sha256 cellar: :any_skip_relocation, ventura:        "3a3f9b8d96811bfdb28955b50c81f60cb41c2103537214ce0d40bb0b95855121"
    sha256 cellar: :any_skip_relocation, monterey:       "45c9e820c1c80b6fc11ff61d4a633b9ce385fd0352b408b3c9cdca1ad009d1be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0da6c7db54a25d266004448beb72da5feb348ce34381f70ffac5b78af83b91f"
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