require "languagenode"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https:www.typescriptlang.org"
  url "https:registry.npmjs.orgtypescript-typescript-5.5.4.tgz"
  sha256 "2680b6354d462a1d90a2cf10c790e071f1c45081c9d4561cb47ce23c934d8586"
  license "Apache-2.0"
  head "https:github.comMicrosoftTypeScript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "25b52ba2261a608f73fe5eb6cb4f1289106de099ce3d7f396609fffd373d0fb1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25b52ba2261a608f73fe5eb6cb4f1289106de099ce3d7f396609fffd373d0fb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25b52ba2261a608f73fe5eb6cb4f1289106de099ce3d7f396609fffd373d0fb1"
    sha256 cellar: :any_skip_relocation, sonoma:         "25b52ba2261a608f73fe5eb6cb4f1289106de099ce3d7f396609fffd373d0fb1"
    sha256 cellar: :any_skip_relocation, ventura:        "25b52ba2261a608f73fe5eb6cb4f1289106de099ce3d7f396609fffd373d0fb1"
    sha256 cellar: :any_skip_relocation, monterey:       "25b52ba2261a608f73fe5eb6cb4f1289106de099ce3d7f396609fffd373d0fb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8de159428e45a63d940c2cf360d435a89db9bd9bd7089075b6f66977b635d8ee"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test.ts").write <<~EOS
      class Test {
        greet() {
          return "Hello, world!";
        }
      };
      var test = new Test();
      document.body.innerHTML = test.greet();
    EOS

    system bin"tsc", "test.ts"
    assert_predicate testpath"test.js", :exist?, "test.js was not generated"
  end
end