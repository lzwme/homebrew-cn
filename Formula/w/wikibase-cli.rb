class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https:github.commaxlathwikibase-cli"
  url "https:registry.npmjs.orgwikibase-cli-wikibase-cli-18.3.2.tgz"
  sha256 "705a23412c9cee7fafdf01c5a5b242cdc0849fe587295765a86b0f12fbce6c1f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c2709ae98f0299490401c329a8507be24be4e66faf0d7634cdb2f8159702c27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c2709ae98f0299490401c329a8507be24be4e66faf0d7634cdb2f8159702c27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c2709ae98f0299490401c329a8507be24be4e66faf0d7634cdb2f8159702c27"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5a1fa3f7a66538833c9d2728917e7ced5a7c9e5e7682d5c453f3c663d1f89c1"
    sha256 cellar: :any_skip_relocation, ventura:       "d5a1fa3f7a66538833c9d2728917e7ced5a7c9e5e7682d5c453f3c663d1f89c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5c2709ae98f0299490401c329a8507be24be4e66faf0d7634cdb2f8159702c27"
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