require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.24.8.tgz"
  sha256 "345ef64b74e9114e98296b8ac835490d1bfa648849cb9c3e6c62e7c9804cb790"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a52251dd5c1478e11f349827c3d6f08d3303586729a47b1f10aea129134cbd11"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a52251dd5c1478e11f349827c3d6f08d3303586729a47b1f10aea129134cbd11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a52251dd5c1478e11f349827c3d6f08d3303586729a47b1f10aea129134cbd11"
    sha256 cellar: :any_skip_relocation, sonoma:         "a52251dd5c1478e11f349827c3d6f08d3303586729a47b1f10aea129134cbd11"
    sha256 cellar: :any_skip_relocation, ventura:        "a52251dd5c1478e11f349827c3d6f08d3303586729a47b1f10aea129134cbd11"
    sha256 cellar: :any_skip_relocation, monterey:       "a52251dd5c1478e11f349827c3d6f08d3303586729a47b1f10aea129134cbd11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72a45f3f3a9af0629b432d275b8971f02f37c01048906cf7fd6d6e32f355fac0"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.24.8.tgz"
    sha256 "989e83a3bc6786ae13b6f7dee71c4cfc1c7abbbaa2afb915c3f8ef4041dc2434"
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