require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.203.0.tgz"
  sha256 "7d956e939f4ededf55a45c2ef207962ad595488f619333d126c85de776f156f4"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https:registry.npmjs.orgrenovatelatest"
    regex(v?(\d+(?:\.\d+)+)i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccd280c883d9d027688caa034252d1a23e1ab0ebeacfc6c7bff9db1e891b81b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "45e9d2b3b580e6544dc5449c507fa5e8b9166a55c3d0c6f75c404183da6a11ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87123b1426f699c5e98bd016aafa206129d7321a4a5d19dc487fe0a9ad4e457b"
    sha256 cellar: :any_skip_relocation, sonoma:         "c8a1ceb375d8445c2bd2471016a99d1d24afff0073444909a24286807100106b"
    sha256 cellar: :any_skip_relocation, ventura:        "58e82f8e85726a0834f28d8be690752dcbecfea0b219e40bc1a0138251027731"
    sha256 cellar: :any_skip_relocation, monterey:       "6660df026c617e0a9bbdce97a70bd26910d0f00d139a6ab997385396031588a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ed5467662dd43bab6b3e92e8c9492c800e9802c945be8d82c1cb0a726fe9bb9"
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