require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.180.0.tgz"
  sha256 "6f9d9944c42e825f6b3b8a020a008aa48772d3734a4797ee486666f984976e1a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dacb9a7c728d16ec2d3bfaf828e8dd9bfe10796ef713a9dc6484a1b058ab54ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9b20301159050b671931b2e030d513c47ee117424d95c4b4e8b697b759f3106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58c7f9c567a7861dd5f5c0d65f0ff728bfcd9969875ae83b4e66be811de9d5bc"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a7a04e28d26eb9eb07b71106eaa0fee3c3ab3e4cebe1585b224a49d67d948ff"
    sha256 cellar: :any_skip_relocation, ventura:        "089d119b7662491666bdda2080dcb5283ce33677364a3fc5d56a2b6e8bc7408f"
    sha256 cellar: :any_skip_relocation, monterey:       "dbabf08507c2f7eeb3134db7236958b877df9f6fb794483c8b07424d00bb142e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c64cdc75cf2972238c1930f04560c844743e9619df960950c581cbadea8c99b"
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