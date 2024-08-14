class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-38.27.0.tgz"
  sha256 "2d025531a908c7231bf196e5286f16553920966f1fd3035dca2c7bc23ac0c1b0"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fe71f32f80c693fc0880891585fb5a739a77215df4c7207a9fd9650ece0a930d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "97cfee2466163e62bd7865ee94314ed686c521a4826e1b9b16c79e0b44924f1b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02a8d4da0c993317deac57c8db72347109d837aa05b9f646ec97d5424bf9660b"
    sha256 cellar: :any_skip_relocation, sonoma:         "90cdfae6f75082c7af4c9b16644cd7090b990d3fcb2485a712cc1eb0e7c7b63b"
    sha256 cellar: :any_skip_relocation, ventura:        "5e30ae8ae9de6cf8f19ed8d738a4c346da277fa8bd3e1ab1cf215db02ec59119"
    sha256 cellar: :any_skip_relocation, monterey:       "f9a7267bf83ef1a247f3fe8102aecaa66649ee2eca7cbc1f6a0a10b5a496ee34"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32a44f16c001a9df3ab48d0311990761e33227066c41d358049ab39036a256dd"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}renovate 2>&1", 1)
  end
end