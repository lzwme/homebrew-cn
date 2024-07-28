require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.8.0.tgz"
  sha256 "23b3e5c0e841ab7c09dc158f29fef07ee0f6ac6bad67d7e83dfed895e9d1fcca"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c38fae6a722aa3a6cdaf91066bee28df79f0004693ae9e228d29f94f71fb628"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6cd77a6790a0cf54b5ce832dcb6edcf6664557cbc4c998f5c644b14d7719521"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30e5d00fccaabf4105ed15cfdeb25aaf49b8cb3a4c24e9dac28e26feaa108425"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a8b06a91e70fc5a6de5f434141880b95d2ef670d60068969b0b57f0d6ef63ca"
    sha256 cellar: :any_skip_relocation, ventura:        "50d8c6078a19dc9d5c447d8358bd18fd99ffde4f201bd70e72ee12ceefee6120"
    sha256 cellar: :any_skip_relocation, monterey:       "bbffac2ab25fd72cbc0359d5bc2f07d8f62cc0446e59a652ee7e002616e7b70b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6ff1d358f93905c74f4802ccea2a89a8b141af2770108c5b97db0ed6de8ef51"
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