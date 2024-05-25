require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.377.0.tgz"
  sha256 "4bef130df4c6afc0166810fe439178db3291034d37e8f821ac86fece87831431"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "af2dcd4fde5cb2717485d1d4c5275268bac406effeb8eb3705507379336f58be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec29291b7b6fd4e464f050065ec2f1fef42a356c7d0ffa17d74a9bd903719bb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bec8738d9b7173c1b3ee40903e90c80b601971c49dcacaad760743f2d4e8faa3"
    sha256                               sonoma:         "204bfe87f376b5511dd1899424cedaeae47004d4fddac7e610ed60d9559268cd"
    sha256                               ventura:        "2f6a906656239c2594301a94dd6bcdef5100d4ced72f20cff4d6221e6c172f0d"
    sha256                               monterey:       "a433e36c7a08fc47ae527a8223d40328e74be09a72146c6987213c4e31edda05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f4aca82c9c7193b232d70d7126454bc7a2ce72cf49e25f7ccd7c52a573e7026"
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