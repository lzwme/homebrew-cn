require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.24.9.tgz"
  sha256 "21de1e80f822413c8ceea3b299df7b260cc0bf8cf0722b708e0a8ebc7e1bbd95"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d9167302f71686a2e493cf0fe3bbd30e0af378a8260915e799981d86314142ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9167302f71686a2e493cf0fe3bbd30e0af378a8260915e799981d86314142ca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9167302f71686a2e493cf0fe3bbd30e0af378a8260915e799981d86314142ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "8db65cad4746608832cddc36aab5d16059ccfda0f2c7f4bef05e06977afe3de7"
    sha256 cellar: :any_skip_relocation, ventura:        "3a540d0c6d7569f80cb29d0da9551483bd7a360f8748a0b7b2941a9b9c4a0830"
    sha256 cellar: :any_skip_relocation, monterey:       "d9167302f71686a2e493cf0fe3bbd30e0af378a8260915e799981d86314142ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d9d3edb1e988bda520c4d19277d76e9bcdaab3f9cedb981a5c428376764b9af"
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