require "languagenode"

class Typescript < Formula
  desc "Language for application scale JavaScript development"
  homepage "https:www.typescriptlang.org"
  url "https:registry.npmjs.orgtypescript-typescript-5.5.3.tgz"
  sha256 "f47d21b40c99188b4158f8a444f132207957d528b1f80ccbc019ce9c4765c3d1"
  license "Apache-2.0"
  head "https:github.comMicrosoftTypeScript.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "356dcef9f8ad0f1789d1f295c71085c9ba5f631fe037f26c5633b966be9df9b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "356dcef9f8ad0f1789d1f295c71085c9ba5f631fe037f26c5633b966be9df9b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "356dcef9f8ad0f1789d1f295c71085c9ba5f631fe037f26c5633b966be9df9b2"
    sha256 cellar: :any_skip_relocation, sonoma:         "356dcef9f8ad0f1789d1f295c71085c9ba5f631fe037f26c5633b966be9df9b2"
    sha256 cellar: :any_skip_relocation, ventura:        "356dcef9f8ad0f1789d1f295c71085c9ba5f631fe037f26c5633b966be9df9b2"
    sha256 cellar: :any_skip_relocation, monterey:       "356dcef9f8ad0f1789d1f295c71085c9ba5f631fe037f26c5633b966be9df9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a7b3199e241f01b3983e59c69a08a242a4715a0e2cc84f979b5b9281b0d546a"
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