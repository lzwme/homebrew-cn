require "language/node"

class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-17.7.2.tgz"
  sha256 "d268c88c1b2ecc4efe8738b18f61128ae8003fe7def2a4197751aa9a0631633f"
  license "MIT"
  head "https://github.com/conventional-changelog/commitlint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "30dd89eef718b2e04b17c0f4f8e9aac736d8702a6f978ee57dfe920208f01af1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30dd89eef718b2e04b17c0f4f8e9aac736d8702a6f978ee57dfe920208f01af1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30dd89eef718b2e04b17c0f4f8e9aac736d8702a6f978ee57dfe920208f01af1"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef60a6ce442141d8d8e462e79da802e87690303da03ca44c93552006a88fd1f9"
    sha256 cellar: :any_skip_relocation, ventura:        "ef60a6ce442141d8d8e462e79da802e87690303da03ca44c93552006a88fd1f9"
    sha256 cellar: :any_skip_relocation, monterey:       "ef60a6ce442141d8d8e462e79da802e87690303da03ca44c93552006a88fd1f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "30dd89eef718b2e04b17c0f4f8e9aac736d8702a6f978ee57dfe920208f01af1"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"commitlint.config.js").write <<~EOS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    EOS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_equal "", pipe_output("#{bin}/commitlint", "foo: message")
  end
end