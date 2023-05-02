require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.21.5.tgz"
  sha256 "2b197e22870bc4c25a7595b99400cbf455edb8cac4eb4d3cc65888c51aa3ad92"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22072e4ee80f9f13faad53b2b839451fc6faf9bd7efe26025aeb3648a00f002e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22072e4ee80f9f13faad53b2b839451fc6faf9bd7efe26025aeb3648a00f002e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22072e4ee80f9f13faad53b2b839451fc6faf9bd7efe26025aeb3648a00f002e"
    sha256 cellar: :any_skip_relocation, ventura:        "22072e4ee80f9f13faad53b2b839451fc6faf9bd7efe26025aeb3648a00f002e"
    sha256 cellar: :any_skip_relocation, monterey:       "22072e4ee80f9f13faad53b2b839451fc6faf9bd7efe26025aeb3648a00f002e"
    sha256 cellar: :any_skip_relocation, big_sur:        "22072e4ee80f9f13faad53b2b839451fc6faf9bd7efe26025aeb3648a00f002e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33b1737e3117f01b133ffe42d4268204ebe7434ed7d9fa7635619cd842bd694d"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.21.5.tgz"
    sha256 "4a0f15bfaee333504ddebc7a69487fd2fc21bb9d059c81e526f8ae548a2acc85"
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