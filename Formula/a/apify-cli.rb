require "language/node"

class ApifyCli < Formula
  include Language::Node::Shebang

  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.18.0.tgz"
  sha256 "28d4e8b032992560a4f842a44e8d107693b1a031560325b90967245c4ed7b628"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "802f8c1cf03eeb7659b20f828cdcc159e0a7b997740588d6425ebff59b25d125"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "802f8c1cf03eeb7659b20f828cdcc159e0a7b997740588d6425ebff59b25d125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "802f8c1cf03eeb7659b20f828cdcc159e0a7b997740588d6425ebff59b25d125"
    sha256 cellar: :any_skip_relocation, ventura:        "3af99666d80914b27b55b280f24a6df0bae6ba2a152aceec5745858793291e01"
    sha256 cellar: :any_skip_relocation, monterey:       "3af99666d80914b27b55b280f24a6df0bae6ba2a152aceec5745858793291e01"
    sha256 cellar: :any_skip_relocation, big_sur:        "3af99666d80914b27b55b280f24a6df0bae6ba2a152aceec5745858793291e01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af7b7e58cf0ac81b7ab3530dc45c154ac023ca8b46ef1bc5d946936dbae01a55"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    # We have to replace the shebang in the main executable from "/usr/bin/env node"
    # to point to the Homebrew-provided `node`,
    # because otherwise the CLI will run with the system-provided Node.js,
    # which might be a different version than the one installed by Homebrew,
    # causing issues that `node_modules` were installed with one Node.js version
    # but the CLI is running them with another Node.js version.
    rewrite_shebang detected_node_shebang, libexec/"lib/node_modules/apify-cli/src/bin/run"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    # Test that the Apify CLI is at all installed and working
    assert_match "apify-cli/#{version}", shell_output("#{bin}/apify --version")
    # Test that the CLI can initialize a new actor
    system "#{bin}/apify", "init", "testing-actor"
    assert_predicate testpath/".actor/actor.json", :exist?
  end
end