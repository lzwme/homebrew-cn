class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-39.45.0.tgz"
  sha256 "98711a435bef906692e90147ec72d01b5295f00087b5d0f2052c5998fc3df392"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84aa66393f4fe27b9442f0e84b4c714e366a78a42b96bc52bc845b3ebec96263"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41a8d4e5fd416637c6df1771e6f344eee8d71acbe88b1b39c530b27688008bdd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a494c94d7cdfd912da2a96ee84bcb6927e72586ecfa8ad76533ae51b49b2904f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7430c1d95c8b82381bfdeb4f10c21cbbc8a9dcebb4a65b63d11d2b4e55e36a8a"
    sha256 cellar: :any_skip_relocation, ventura:       "d7f10b2188bbad4573966f380043f321741a63a223b8f947fed6338058fc5f95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d27fd9e35d0cb9b1d88e3c77ed338ce682b82eb50a179bdba0605b4de78c35c8"
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