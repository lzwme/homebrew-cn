class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https:github.commaxlathwikibase-cli"
  url "https:registry.npmjs.orgwikibase-cli-wikibase-cli-18.3.0.tgz"
  sha256 "40a3d289e43d28caacc72bfa54f671037292b6a5c103bab33e9355d1fa6e38c1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b1b147779b35017530569c1a7a9512e76c404fd6ef3b5a4fbdaddcf95910f63"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b1b147779b35017530569c1a7a9512e76c404fd6ef3b5a4fbdaddcf95910f63"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b1b147779b35017530569c1a7a9512e76c404fd6ef3b5a4fbdaddcf95910f63"
    sha256 cellar: :any_skip_relocation, sonoma:        "30669093f23d7e3da4628175fdaf08001e1f69edd3ba08a4d5baed5dddc3833c"
    sha256 cellar: :any_skip_relocation, ventura:       "30669093f23d7e3da4628175fdaf08001e1f69edd3ba08a4d5baed5dddc3833c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b1b147779b35017530569c1a7a9512e76c404fd6ef3b5a4fbdaddcf95910f63"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    config_file = testpath".wikibase-cli.json"
    config_file.write "{\"instance\":\"https:www.wikidata.org\"}"

    ENV["WB_CONFIG"] = config_file

    assert_equal "human", shell_output("#{bin}wd label Q5 --lang en").strip

    assert_match version.to_s, shell_output("#{bin}wd --version")
  end
end