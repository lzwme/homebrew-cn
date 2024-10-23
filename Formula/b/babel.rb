require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.25.9.tgz"
  sha256 "32f442ac82ff8793dfffd6aac01836688820a05f037018b7b789e990dba68014"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "321edc4d3c5fbf80c6cf485221627325e4a5280d87c80ad9daabbf993777c0b6"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"script.js").write <<~EOS
      [1,2,3].map(n => n + 1);
    EOS

    system bin/"babel", "script.js", "--out-file", "script-compiled.js"
    assert_predicate testpath/"script-compiled.js", :exist?, "script-compiled.js was not generated"
  end
end