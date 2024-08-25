class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https:www.typescriptlang.org"
  url "https:registry.npmjs.orgtypescript-typescript-5.5.4.tgz"
  sha256 "2680b6354d462a1d90a2cf10c790e071f1c45081c9d4561cb47ce23c934d8586"
  license "Apache-2.0"
  head "https:github.comMicrosoftTypeScript.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "822f45e678ec43dbfecc36a60c127f287df0f5d6f53f81095be64d38427bc957"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
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