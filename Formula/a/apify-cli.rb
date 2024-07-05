require "language/node"

class ApifyCli < Formula
  include Language::Node::Shebang

  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.20.2.tgz"
  sha256 "dfe8bf7a168cf221ef85380b78c3b7b56c1b19b059f8ec4003f3e9c9c2bd6bb0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b4a1a87d5b03c8ba002b879b6254aa8edde076a7adeeee92c186eef31f2efdd2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4a1a87d5b03c8ba002b879b6254aa8edde076a7adeeee92c186eef31f2efdd2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4a1a87d5b03c8ba002b879b6254aa8edde076a7adeeee92c186eef31f2efdd2"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b827b72e552d84f7783133d1c8bbc8c9970e4152a0ff5c6680713d1fb65ca5a"
    sha256 cellar: :any_skip_relocation, ventura:        "3b827b72e552d84f7783133d1c8bbc8c9970e4152a0ff5c6680713d1fb65ca5a"
    sha256 cellar: :any_skip_relocation, monterey:       "3b827b72e552d84f7783133d1c8bbc8c9970e4152a0ff5c6680713d1fb65ca5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f37274bf651075a49f2bcfea9071fbce5d0e5539b210641df7e7fa36186b8882"
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
    rewrite_shebang detected_node_shebang, libexec/"lib/node_modules/apify-cli/bin/run.js"
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/apify init -y testing-actor 2>&1")
    assert_includes output, "Success: The Actor has been initialized in the current directory"
    assert_predicate testpath/"storage/key_value_stores/default/INPUT.json", :exist?

    assert_includes shell_output("#{bin}/apify --version 2>&1"), version.to_s
  end
end