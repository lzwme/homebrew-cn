class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https:commitlint.js.org#"
  url "https:registry.npmjs.orgcommitlint-commitlint-19.3.0.tgz"
  sha256 "a2cb9218f086e8877691e7b7002b2f20cde823cb27a87c0255fdcbf74dde5e46"
  license "MIT"
  head "https:github.comconventional-changelogcommitlint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "835bb470798abd5172a8ae23a1b7b2ddf39b0897606846f44813b1abf617a206"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "835bb470798abd5172a8ae23a1b7b2ddf39b0897606846f44813b1abf617a206"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "835bb470798abd5172a8ae23a1b7b2ddf39b0897606846f44813b1abf617a206"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0a9903caf955420e1ed47ab5fd01a54dec1db45460fb20b9bc2282a1fd4b8e6"
    sha256 cellar: :any_skip_relocation, ventura:        "c0a9903caf955420e1ed47ab5fd01a54dec1db45460fb20b9bc2282a1fd4b8e6"
    sha256 cellar: :any_skip_relocation, monterey:       "c0a9903caf955420e1ed47ab5fd01a54dec1db45460fb20b9bc2282a1fd4b8e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a91a1e8ad08df01e00e0b2a841f6d17090d5306c3da1dc39358826d08142e6dc"
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
    assert_equal "", pipe_output("#{bin}commitlint", "foo: message")
  end
end