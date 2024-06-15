require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.408.0.tgz"
  sha256 "d5ed7caf954f16f657b74fd4a7b516907bd88e05d40b62a8e13b59ecec492cb1"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "977f11d8cb1676d0b2c64295d5d3cec6ee7024d603b8fc49f7b50d94478e1ef6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3cb844c9576fc0d747d21fd93b55570b9c741b04b9878c6a3789dc71e1e65dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "844f409d684a076a77bd174069f204e9371200e6afc823bb580c9eed68ca2a00"
    sha256 cellar: :any_skip_relocation, sonoma:         "4ddf477748d2cd3f5461585d6b160ea45fde7e16533ee339037abbfd936e70e5"
    sha256 cellar: :any_skip_relocation, ventura:        "93d6237f42402e29719cd1498fac29c9badae74ab8b8ad6a2059a2e7456d8309"
    sha256 cellar: :any_skip_relocation, monterey:       "288507ecee03d8c90c54a6265f80e73f1f60790a4af67f2d3d1ddd82ada4fd9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "568ac52e82c68d18586034eefbfafce6d2551b5b12482cf80c947357ac702e77"
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