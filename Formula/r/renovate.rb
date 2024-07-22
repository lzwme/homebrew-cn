require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.438.0.tgz"
  sha256 "375979c2e90707fe2bb3025d18b8990be315c160af8d147a12f79536fa7894f7"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d456b7828364fd2e26752886c945ce079a7b6751b21ad2a2d9e5f35c6c55de1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5b73718e298ec35c815005e7b80dff64c672af8ad03f30229a2376a97c938b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f35386d3a03c3598a6c6d3d714f3ed252ef8938919b2913c9ec268ff1f02333c"
    sha256 cellar: :any_skip_relocation, sonoma:         "b57d66d5271d3a4e5bfd52af785ff2eee0204204e17a1e41e4b5231bf010bf62"
    sha256 cellar: :any_skip_relocation, ventura:        "1e9fb62293cb137c0ac22377b0530c900e3e74e355eecf62d96c21d5e0e53afb"
    sha256 cellar: :any_skip_relocation, monterey:       "bb084ca96369794bf6d99aa06b7d89428c42b3c05d5606f5cda2d79cb68556aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6588c1ef9f197f3c229395c0f5ce3f13243a0cdca202e6a9b82dcbe8aa8b6c27"
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