require "languagenode"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https:commitlint.js.org#"
  url "https:registry.npmjs.orgcommitlint-commitlint-18.6.0.tgz"
  sha256 "0b0b780739539423de54a0d1ac46a3f7e079a01314812fda8705b0a927018ee3"
  license "MIT"
  head "https:github.comconventional-changelogcommitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b191c15566bbe81d4b541c5e1b1f3754929ad7998be3e2f56aa6d7eef16f1c9f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b191c15566bbe81d4b541c5e1b1f3754929ad7998be3e2f56aa6d7eef16f1c9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b191c15566bbe81d4b541c5e1b1f3754929ad7998be3e2f56aa6d7eef16f1c9f"
    sha256 cellar: :any_skip_relocation, sonoma:         "283d650abff732333deded832f418de08327aa13a033136bca949fa1a8917c39"
    sha256 cellar: :any_skip_relocation, ventura:        "283d650abff732333deded832f418de08327aa13a033136bca949fa1a8917c39"
    sha256 cellar: :any_skip_relocation, monterey:       "283d650abff732333deded832f418de08327aa13a033136bca949fa1a8917c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b191c15566bbe81d4b541c5e1b1f3754929ad7998be3e2f56aa6d7eef16f1c9f"
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