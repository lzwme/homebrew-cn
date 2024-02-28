require "languagenode"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https:commitlint.js.org#"
  url "https:registry.npmjs.orgcommitlint-commitlint-19.0.1.tgz"
  sha256 "8900fdcdad0a9fd062d9d880c7fb48931c7d6c19d3e03b79c4450f4128edf8f2"
  license "MIT"
  head "https:github.comconventional-changelogcommitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5795ead91987381eb1c839bee8e481c5c90714a4a79bc0d02fcbf4f400c69e7d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5795ead91987381eb1c839bee8e481c5c90714a4a79bc0d02fcbf4f400c69e7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5795ead91987381eb1c839bee8e481c5c90714a4a79bc0d02fcbf4f400c69e7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad20771e9d15a8fa2f9b799720c4ffe21377908e952c10a4722a5f4e3a51c549"
    sha256 cellar: :any_skip_relocation, ventura:        "ad20771e9d15a8fa2f9b799720c4ffe21377908e952c10a4722a5f4e3a51c549"
    sha256 cellar: :any_skip_relocation, monterey:       "ad20771e9d15a8fa2f9b799720c4ffe21377908e952c10a4722a5f4e3a51c549"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5795ead91987381eb1c839bee8e481c5c90714a4a79bc0d02fcbf4f400c69e7d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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
    assert_equal "", pipe_output("#{bin}commitlint", "foo: message")
  end
end