class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https:commitlint.js.org#"
  url "https:registry.npmjs.orgcommitlint-commitlint-19.4.1.tgz"
  sha256 "dca3b674ab9bdfa412d47da0a0eee00607d4c413085297fed4fad49d76ecfbd4"
  license "MIT"
  head "https:github.comconventional-changelogcommitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f21d3e34c9ddf930b2949d932ced3b91f35ae33ac4015cbdbf774e7dea43fc9d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f21d3e34c9ddf930b2949d932ced3b91f35ae33ac4015cbdbf774e7dea43fc9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f21d3e34c9ddf930b2949d932ced3b91f35ae33ac4015cbdbf774e7dea43fc9d"
    sha256 cellar: :any_skip_relocation, sonoma:         "51d8924a30562ef87ff914da467c407910bf32071fe5a8fa5156a73db42c6946"
    sha256 cellar: :any_skip_relocation, ventura:        "51d8924a30562ef87ff914da467c407910bf32071fe5a8fa5156a73db42c6946"
    sha256 cellar: :any_skip_relocation, monterey:       "51d8924a30562ef87ff914da467c407910bf32071fe5a8fa5156a73db42c6946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f21d3e34c9ddf930b2949d932ced3b91f35ae33ac4015cbdbf774e7dea43fc9d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"commitlint.config.js").write <<~EOS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    EOS
    assert_match version.to_s, shell_output("#{bin}commitlint --version")
    assert_equal "", pipe_output(bin"commitlint", "foo: message")
  end
end