class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-20.2.0.tgz"
  sha256 "d00f865f1ed4f52be8feccc857255f6a53dd82ec80610abe833f96aa49cbbf2f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b42b64705ebb34a36c5d86c5cf72ad19065b92a7c599f5de5a474ffe8df76e7f"
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