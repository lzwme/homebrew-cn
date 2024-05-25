require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.24.6.tgz"
  sha256 "ccfe39da16c5ed3385ef1b46451392e3235a9bc81fd1a5c95c37bb7703d1a5d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c17ab8dcf4b45bf79a059a6b08ff037dbb38441ee8a1195027e00daae94a5a2f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa47a909fb648a87ae50ffb9991cd3e15f2b459e69232bcfb99a2235f2a8e419"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3d2cc46229f48790b8949bc376968f7f06d50d77e39716617b15f5384028a37"
    sha256 cellar: :any_skip_relocation, sonoma:         "5cf76bba3e2cc82219173dc2b56303820caea2e710c535e5874eea84cfa79dbc"
    sha256 cellar: :any_skip_relocation, ventura:        "88c7cfe17535fdcf7435831a3533e76924f426b1012538dd8c51ef33827a38a8"
    sha256 cellar: :any_skip_relocation, monterey:       "712c5b04f42aff1362e873fd0ad599897134ab048e9fc90ea9e09a76ebc1fe69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d8d0aa959bbb7f2e3626b3e91df5f24b85385105769514781b62198083f413c"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.24.6.tgz"
    sha256 "a42ecfc6075deff074365dbd56d2378b15ec6715180451bcc00036ca6a96592d"
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