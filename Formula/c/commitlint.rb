class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-20.4.2.tgz"
  sha256 "bd6db1b625989bbc6c490d4373eb87e333a054acb3d8c77d3bb6ae3f653a2ff4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6f07b8059bbd54802bb7cd0581f5f9dad59f7ea761bf42f6914c1787ec45d1f7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"commitlint.config.js").write <<~JS
      module.exports = {
          rules: {
            'type-enum': [2, 'always', ['foo']],
          },
        };
    JS
    assert_match version.to_s, shell_output("#{bin}/commitlint --version")
    assert_empty pipe_output(bin/"commitlint", "foo: message")
  end
end