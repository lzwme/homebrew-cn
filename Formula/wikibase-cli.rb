require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-17.0.2.tgz"
  sha256 "501577770673912c39e4c9752b7dd4359b650c86a4a71abc9d89505644340ef4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6d23b53272631230ec65583f3436a1a0bf22652a0e246282e2c55f79586efe8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6d23b53272631230ec65583f3436a1a0bf22652a0e246282e2c55f79586efe8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6d23b53272631230ec65583f3436a1a0bf22652a0e246282e2c55f79586efe8"
    sha256 cellar: :any_skip_relocation, ventura:        "a847976a64773d9679a1f9a5d13fb11173d34343cd94254b55b91bad830b1930"
    sha256 cellar: :any_skip_relocation, monterey:       "a847976a64773d9679a1f9a5d13fb11173d34343cd94254b55b91bad830b1930"
    sha256 cellar: :any_skip_relocation, big_sur:        "a847976a64773d9679a1f9a5d13fb11173d34343cd94254b55b91bad830b1930"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "727f7b4d71a12f7820185e808f1ab29a86edd848c6c978d45487292de4359145"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip
  end
end