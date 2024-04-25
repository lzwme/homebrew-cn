require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.321.0.tgz"
  sha256 "67d95c08cfb0a51ab5a1916f2b1bb5e36caf617b7b967e6cd002d380acba2e1c"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9c17eb3f995d1cef2afa514d3189c01f337e9e992b22f713997ba284784f2ee8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36f368f21b0f9e0bfd84caddd48aadf003882eaa97afd66d6da0524463149c05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6af9951714ec3526a6c91fc8f5a09aa448acdfea294de987a2d12457370b1030"
    sha256 cellar: :any_skip_relocation, sonoma:         "75d3a317674a3aaf30cf7c39c154bd1f0aed5c1a9bf547065a96eebdf04b4822"
    sha256 cellar: :any_skip_relocation, ventura:        "a08941759c5d97cfb4dc884110fe18c31888da66ad0db4afa483fbcc62169341"
    sha256 cellar: :any_skip_relocation, monterey:       "2e87747c39ea2b8a2b81e1d20bd06b4d9630df412781d028d077e47053561642"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46a499d6211061fed99ed668be7a434280bcd1d8fce516919f2504cddd44b536"
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