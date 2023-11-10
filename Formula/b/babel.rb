require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.23.3.tgz"
  sha256 "fcdc5fd41543c20212a620e668192baacc1fe7ee5e73e84786da39f6a53747f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff57c0eb996208b576dab97777febfe93483d6d46334130127c8408d22d25928"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ff57c0eb996208b576dab97777febfe93483d6d46334130127c8408d22d25928"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff57c0eb996208b576dab97777febfe93483d6d46334130127c8408d22d25928"
    sha256 cellar: :any_skip_relocation, sonoma:         "ff57c0eb996208b576dab97777febfe93483d6d46334130127c8408d22d25928"
    sha256 cellar: :any_skip_relocation, ventura:        "ff57c0eb996208b576dab97777febfe93483d6d46334130127c8408d22d25928"
    sha256 cellar: :any_skip_relocation, monterey:       "ff57c0eb996208b576dab97777febfe93483d6d46334130127c8408d22d25928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd7bfaff640a8603b751a64e16eae1b661e3626db10b93feaa426e95756b94c4"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.23.0.tgz"
    sha256 "3c47bb2c36fd66e39ab5c62bdcf47b20dadcd62fd45ad62c2d1c1699af23c2b2"
  end

  def install
    (buildpath/"node_modules/@babel/core").install Dir["*"]
    buildpath.install resource("babel-cli")

    cd buildpath/"node_modules/@babel/core" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--production"
    end

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
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