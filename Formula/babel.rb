require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.21.0.tgz"
  sha256 "d06d6317571bd6560daecd5dedfbfb919e0737fec84e2e14f12878f1fb6d857c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77de6994a503032bfd2b3a75c7ebaa4fe50f2f329d82d847a823217c81ebaf1f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77de6994a503032bfd2b3a75c7ebaa4fe50f2f329d82d847a823217c81ebaf1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77de6994a503032bfd2b3a75c7ebaa4fe50f2f329d82d847a823217c81ebaf1f"
    sha256 cellar: :any_skip_relocation, ventura:        "77de6994a503032bfd2b3a75c7ebaa4fe50f2f329d82d847a823217c81ebaf1f"
    sha256 cellar: :any_skip_relocation, monterey:       "77de6994a503032bfd2b3a75c7ebaa4fe50f2f329d82d847a823217c81ebaf1f"
    sha256 cellar: :any_skip_relocation, big_sur:        "77de6994a503032bfd2b3a75c7ebaa4fe50f2f329d82d847a823217c81ebaf1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "207add5a939b20d8673cb755cf0b6135d38ddc113b585f7a783f0fa750a8fb11"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.21.0.tgz"
    sha256 "40d4cc27188a2f9968ed8292eb4a965a460b7386719cf0e5260a82500ef777a6"
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