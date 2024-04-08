require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.280.0.tgz"
  sha256 "dca55569c07b50e38b39f7e77decd1ce4b3547c0c48e4470c4ad37a3ce341b9a"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a8dc5e02b85dabee47099208c9183d259b3c6ceda71962dc8c4aa6095ad60d2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "835d8b7e2bdde53564277a4d4c2a59e7df58c0f02e83001b403a9372a8bd18fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9681208fa9fa76b07345f0867015d3f855b1b191b802a5dc9dc11b73ee6ab6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "e1c6459cbd926cd29e23d6dc026381dfd116a0a264286d70ad56744de804a271"
    sha256 cellar: :any_skip_relocation, ventura:        "6d913ddee5c0fe037a5677ee09e26855e27c324e67bd0c91039d5e696f764a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "b32e01df51f475ce962ff6d46687008abf40e8c150309a61da4a579b32ea2c2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd134a3bad15fa9b9af97fe550d3435f00c26581c49a44abec784acaeb18cb4b"
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