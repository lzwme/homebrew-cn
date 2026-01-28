class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-19.4.2.tgz"
  sha256 "7e11315b8889f1308ad6b0a2ab5faf9eeb11379ba9e6b4d807c20dccdf26461f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "97dee9003343170449530eecb57b4772d558cabd68eb0045763470fcbe0d1a92"
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