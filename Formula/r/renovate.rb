class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.142.0.tgz"
  sha256 "32bfa46f705ae23dbb6f287c5feaa4107c69d784c32e8d9d3cf2771ac9b0f757"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e70c9e1ba5c9f03745f07671d40c08966794044c59b9361f7fa8dd57bac0b846"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "04f340502469f8b655ce547296aa650aa5bde53ff41f9c4c462dc70c43041214"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a6840a14beabeca923c3e14dd029c4d6add1b4d69e3aed556986ac2fcf92ada3"
    sha256 cellar: :any_skip_relocation, sonoma:        "82dd87119c511ce0fb718740140cfcede2e6fa1fce47de224ea8aa77dc67b874"
    sha256 cellar: :any_skip_relocation, ventura:       "8cef6fab650042faccecb7a22852196dfcf6bbb8b8b8936eb3199ef5344f1a87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e562e04a56bca3d3699ec609e990d3196d7c0f59b7e6de27a4810e3e4f3c95e"
  end

  depends_on "node@20"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    system bin"renovate", "--platform=local", "--enabled=false"
  end
end