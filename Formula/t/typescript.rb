require "languagenode"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https:www.typescriptlang.org"
  url "https:registry.npmjs.orgtypescript-typescript-5.5.2.tgz"
  sha256 "2f12d2e95610c573b778ac0669497440626c07d6aae6865171e246fce96ddda0"
  license "Apache-2.0"
  head "https:github.comMicrosoftTypeScript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0252c491a4b9cdaf59af0b41d4cc4acb7fabc0500d3480be36e74ca1887e7da5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0252c491a4b9cdaf59af0b41d4cc4acb7fabc0500d3480be36e74ca1887e7da5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0252c491a4b9cdaf59af0b41d4cc4acb7fabc0500d3480be36e74ca1887e7da5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0252c491a4b9cdaf59af0b41d4cc4acb7fabc0500d3480be36e74ca1887e7da5"
    sha256 cellar: :any_skip_relocation, ventura:        "0252c491a4b9cdaf59af0b41d4cc4acb7fabc0500d3480be36e74ca1887e7da5"
    sha256 cellar: :any_skip_relocation, monterey:       "0252c491a4b9cdaf59af0b41d4cc4acb7fabc0500d3480be36e74ca1887e7da5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04877163aecb209e935bf45c52efeb3a4bf146ef0671317206273557e7f61621"
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