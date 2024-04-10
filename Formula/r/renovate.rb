require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.281.0.tgz"
  sha256 "ed20fc0826af4939b4b93e0aa15b421610c009c911b3ec7b386a5a31a2a3acaf"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9cf2b007d0b1ae209f21f1dfc3ce22c94cadff9154c86193c7df1d32ac23ed2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3873f66419e6df8a13d0c8b2ddc4267a4de4a92bc2b4df5b01f1b4b3e86a1abe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d6ed83f864ec82b226e1f0f4d9f0f8b6c51d5ca3d64064a1b406223039f91753"
    sha256 cellar: :any_skip_relocation, sonoma:         "615d69aeec5dcd59cd3e596d60c204ec020a1e2ff34f692de8f37f10d395071e"
    sha256 cellar: :any_skip_relocation, ventura:        "bc1ef737a418b0722911767fd307df8064f8fcf14bb4254102636f89444a81e8"
    sha256 cellar: :any_skip_relocation, monterey:       "b4221849b9a9774e50867a9ac3962b93a3726d2256b95c367f8cc6ef8df5de7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f560c1a82a3e5d3231aef92bfb136f1025d4485928690b75265aa3dfddd53ef"
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