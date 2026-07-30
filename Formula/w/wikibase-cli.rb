class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://codeberg.org/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-20.2.0.tgz"
  sha256 "075939ba87e31cc7cc6ce8c33c1b71e36b549e362d5e3362023d1dc1e1f663b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "88d057630bf32d8151c2618c3b438e19fedf8b0722291744a2553fcb2028900b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    config_file = testpath/".wikibase-cli.json"
    config_file.write "{\"instance\":\"https://www.wikidata.org\"}"

    ENV["WB_CONFIG"] = config_file

    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip

    assert_match version.to_s, shell_output("#{bin}/wd --version")
  end
end