require "language/node"

class ApifyCli < Formula
  include Language::Node::Shebang

  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.19.1.tgz"
  sha256 "a1c7a06a40448a5ed632aac3d71bae7fd0518846924fdcb5879129e6ae012247"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2300ac7605cd036317e382a5ff1ef116ac8ef4f866b740c08a4cd48c55d5b7b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2300ac7605cd036317e382a5ff1ef116ac8ef4f866b740c08a4cd48c55d5b7b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2300ac7605cd036317e382a5ff1ef116ac8ef4f866b740c08a4cd48c55d5b7b9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5bfa0f36c86a8df1110147e11b2044b23b87eb66b16f36693193a00878e81ec4"
    sha256 cellar: :any_skip_relocation, ventura:        "5bfa0f36c86a8df1110147e11b2044b23b87eb66b16f36693193a00878e81ec4"
    sha256 cellar: :any_skip_relocation, monterey:       "5bfa0f36c86a8df1110147e11b2044b23b87eb66b16f36693193a00878e81ec4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a84c9a070110d25db33a44b53e0d04d154cbc2941962ff5a5908431ec09a6d45"
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
    output = shell_output("#{bin}/apify init -y testing-actor")
    assert_match "Success: The Apify actor has been initialized", output
    assert_predicate testpath/"storage/key_value_stores/default/INPUT.json", :exist?

    assert_match version.to_s, shell_output("#{bin}/apify --version")
  end
end