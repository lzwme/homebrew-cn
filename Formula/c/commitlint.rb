class Commitlint < Formula
  desc "Lint commit messages according to a commit convention"
  homepage "https://commitlint.js.org/#/"
  url "https://registry.npmjs.org/commitlint/-/commitlint-20.4.4.tgz"
  sha256 "5b474f5d6b854a41317becf31fda806959ff2606c393a9aeb870ffa8676547e0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8ad2010b18ccba620f23a04ea64d6ee418aa6af1431ab714a24f38e115f107f5"
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