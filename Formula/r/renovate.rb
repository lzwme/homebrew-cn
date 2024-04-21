require "languagenode"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https:github.comrenovatebotrenovate"
  url "https:registry.npmjs.orgrenovate-renovate-37.313.0.tgz"
  sha256 "b4eddbb9ee0ed5cd66cfe3b5d409d64d2f5df62ad28cd858f34542770eddee4b"
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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "49d68ce1c73135a8e619b36ce9d9f33b091d5660a45820ce80e63e13e16c87ae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cd7c7c8b7efdb2587cc31e3fa35662eff5f60f288e5693bd17947d6ff75ac5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d99688242f1cfddb60d47b4f569b3f30fa29f47e4662ecb4ffe5e5c6227c229"
    sha256 cellar: :any_skip_relocation, sonoma:         "727d036a254710e18b0e5f3a895e65cd28f6c4fff6f85893f7063eecad0b0097"
    sha256 cellar: :any_skip_relocation, ventura:        "4d6ee2101d9c2a8e2093f642b6c10bb9c4edf517290e0139171295c02d50da33"
    sha256 cellar: :any_skip_relocation, monterey:       "bf7156b5ac5d49e153d7686b3ab50223ca5e3b764d17b5b68a7c1ad6e964b372"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbdedc58aa8b711b6c49560e284c17ebacb42dd4af77f7c46a70bb962a9029ae"
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