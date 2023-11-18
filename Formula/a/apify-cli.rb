require "language/node"

class ApifyCli < Formula
  include Language::Node::Shebang

  desc "Apify command-line interface"
  homepage "https://docs.apify.com/cli"
  url "https://registry.npmjs.org/apify-cli/-/apify-cli-0.19.0.tgz"
  sha256 "f4359db5835d7007872a0efde7d82736c6a625107f61139ed06abf64495cafff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c2bcf5f69872e9e6db4dc236160c18b50915f0d71f7dffb64fbb63f2c7bd168"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c2bcf5f69872e9e6db4dc236160c18b50915f0d71f7dffb64fbb63f2c7bd168"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c2bcf5f69872e9e6db4dc236160c18b50915f0d71f7dffb64fbb63f2c7bd168"
    sha256 cellar: :any_skip_relocation, sonoma:         "0896df768350ff184b917652a708d14b9faf76401466049d5be732048f852702"
    sha256 cellar: :any_skip_relocation, ventura:        "0896df768350ff184b917652a708d14b9faf76401466049d5be732048f852702"
    sha256 cellar: :any_skip_relocation, monterey:       "0896df768350ff184b917652a708d14b9faf76401466049d5be732048f852702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8071f6cb42fc55cff6552c5ec504b6fb11eb91e05dd4599de6a4441b7ad443d"
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