require "languagenode"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https:commitlint.js.org#"
  url "https:registry.npmjs.orgcommitlint-commitlint-18.4.4.tgz"
  sha256 "eef2f1bb00bb8e342c2bb37fb09e2d7251bd3a01e9e9d7cb33ad4d2e90f5d7ae"
  license "MIT"
  head "https:github.comconventional-changelogcommitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "89ddd28ff0f045009d9a1a96d284de6c6aeb19c3f06d326134423906e99b0ee4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89ddd28ff0f045009d9a1a96d284de6c6aeb19c3f06d326134423906e99b0ee4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89ddd28ff0f045009d9a1a96d284de6c6aeb19c3f06d326134423906e99b0ee4"
    sha256 cellar: :any_skip_relocation, sonoma:         "b45e6a721a934910b016c0c2528041b06accc9e51d6d935f200f994a8e0d0c0e"
    sha256 cellar: :any_skip_relocation, ventura:        "b45e6a721a934910b016c0c2528041b06accc9e51d6d935f200f994a8e0d0c0e"
    sha256 cellar: :any_skip_relocation, monterey:       "b45e6a721a934910b016c0c2528041b06accc9e51d6d935f200f994a8e0d0c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89ddd28ff0f045009d9a1a96d284de6c6aeb19c3f06d326134423906e99b0ee4"
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