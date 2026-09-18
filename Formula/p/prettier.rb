class Prettier < Formula
  desc "Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML"
  homepage "https://prettier.io/"
  url "https://registry.npmjs.org/prettier/-/prettier-3.9.7.tgz"
  sha256 "57a7b2b4c760cb8b365584826713f44f8efa51398a0c597513b6947ea6c9add3"
  license "MIT"
  head "https://github.com/prettier/prettier.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "14edf823e26310e20cc7718fdfb044aeabec024426cc40b04f321462ec3a4201"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    output = shell_output("#{bin}/prettier test.js")
    assert_equal "const arr = [1, 2];", output.chomp
  end
end