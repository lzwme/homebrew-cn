require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.25.2.tgz"
  sha256 "6873c15a448a1ad6cd7a5b845d20e2348e04abc1a2261354ad3c702689a4ad0a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e1909b2f685fb27c48edb0b1796c7978094378602decc65d6e2a55dde70fccf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e1909b2f685fb27c48edb0b1796c7978094378602decc65d6e2a55dde70fccf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e1909b2f685fb27c48edb0b1796c7978094378602decc65d6e2a55dde70fccf"
    sha256 cellar: :any_skip_relocation, sonoma:         "bb5ef195bc8b9df1db4ba6853e5039b2a517711739cf913a5abafde072faa6b2"
    sha256 cellar: :any_skip_relocation, ventura:        "bb5ef195bc8b9df1db4ba6853e5039b2a517711739cf913a5abafde072faa6b2"
    sha256 cellar: :any_skip_relocation, monterey:       "4e1909b2f685fb27c48edb0b1796c7978094378602decc65d6e2a55dde70fccf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9af7f9fd8b98b7e1aad7b6027241f75dc491a9ee4292db01e2620de818fc451b"
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