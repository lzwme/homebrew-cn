require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.279.0.tgz"
  sha256 "67b6f8b596c743ad347da31668e8e582e2226f0de16335a4773bf0019e5a8a54"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9b9d61e6d4ebd92d27851fa3ff09d6c565fb59cfe98cf0a0f40be6ba1ee4daf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c464b01b6c6423a6d8044d13f1cde26ba8e31a85b58e3f1468e3e81051e7724d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "798b7e24ec2929ffa4b1aa4f91a2b28fc5abbbed38af58a2631c3e6ca6e08fa0"
    sha256 cellar: :any_skip_relocation, sonoma:         "3bf4e1db49a317bd3d80dbff2b3b8225b63878e1a156c44c51fd8cbb1d1daa63"
    sha256 cellar: :any_skip_relocation, ventura:        "99f6a2384235adc6b0795d777d4a4b4b9965a155a8153a66f5a2830b62dce1e2"
    sha256 cellar: :any_skip_relocation, monterey:       "4b35003e80ef134bf873b7d07912c7cb6aee97da4e15dafab3573ebb5e6549a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dd189b511b09d17b85461beaf59eed66038d2d993277d1ca23d0a24cb1808ff"
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