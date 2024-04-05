require "languagenode"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https:www.typescriptlang.org"
  url "https:registry.npmjs.orgtypescript-typescript-5.4.4.tgz"
  sha256 "0a5b3b80f055936eef797431778bbb3c39c1a4d3fcdbea16f9ac9dc343454c48"
  license "Apache-2.0"
  head "https:github.comMicrosoftTypeScript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1f94c2acf04cc1b082442a0bf8190f4abfe8eb2d18306e4a6b28eea59b8ecba0"
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