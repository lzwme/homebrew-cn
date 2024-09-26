require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/cli/-/cli-7.25.6.tgz"
  sha256 "f36fa3adac4dd7f8329a7c9937a026cebb47b6ba84cb20b7965f81aa6bc29ae2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "031f93da70497d56069fa2b4bb3fc3968898c5ce0fda9dcae3dd6c417dae2878"
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