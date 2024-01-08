require "languagenode"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https:github.comquicktypequicktype"
  url "https:registry.npmjs.orgquicktype-quicktype-23.0.81.tgz"
  sha256 "7514814445698f9ee9badd50566b868485164ad88355b67863bb56cb391c0474"
  license "Apache-2.0"
  head "https:github.comquicktypequicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b8dd51ae4869f37237fe3edaaf5d6204dd429a76b13c0d41d8cfaf56d6a78d4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8dd51ae4869f37237fe3edaaf5d6204dd429a76b13c0d41d8cfaf56d6a78d4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8dd51ae4869f37237fe3edaaf5d6204dd429a76b13c0d41d8cfaf56d6a78d4e"
    sha256 cellar: :any_skip_relocation, sonoma:         "fc37d8b829c2bf71cfa453c4eb39b616ffa3044a17aa971d6982bd6042ec2ca0"
    sha256 cellar: :any_skip_relocation, ventura:        "fc37d8b829c2bf71cfa453c4eb39b616ffa3044a17aa971d6982bd6042ec2ca0"
    sha256 cellar: :any_skip_relocation, monterey:       "fc37d8b829c2bf71cfa453c4eb39b616ffa3044a17aa971d6982bd6042ec2ca0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8dd51ae4869f37237fe3edaaf5d6204dd429a76b13c0d41d8cfaf56d6a78d4e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end