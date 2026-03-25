class Oxfmt < Formula
  desc "High-performance formatting tool for JavaScript and TypeScript"
  homepage "https://oxc.rs/"
  url "https://registry.npmjs.org/oxfmt/-/oxfmt-0.42.0.tgz"
  sha256 "df3ba60da9042d4a3d2d58fc8cb16c54593f274af61fcaa904fd368803fcf851"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "583fa785b4e20b4e6e91185af2be3c582a4ff153d2c2c1f2d9d0197f41296f58"
    sha256 cellar: :any,                 arm64_sequoia: "25d4c59abcafa7e58c74acd2baf07d08201f9c97609e2e63ac15fffd3a740da5"
    sha256 cellar: :any,                 arm64_sonoma:  "25d4c59abcafa7e58c74acd2baf07d08201f9c97609e2e63ac15fffd3a740da5"
    sha256 cellar: :any,                 sonoma:        "410323e60583eaa098b06a3e2ad92306ddfc92f6aa960b038f08eb4be1464782"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9f16c0215b8185e7e3f76052f0714596085baa45ba1f7256e76c7c33438f11f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "710dfc716a44a38b3e116607402c957e836a904208fdf35fd38809279ba15761"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"oxfmt", "test.js"
    assert_equal "const arr = [1, 2];\n", (testpath/"test.js").read
  end
end