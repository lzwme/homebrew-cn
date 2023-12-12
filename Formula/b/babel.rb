require "language/node"
require "json"

class Babel < Formula
  desc "Compiler for writing next generation JavaScript"
  homepage "https://babeljs.io/"
  url "https://registry.npmjs.org/@babel/core/-/core-7.23.6.tgz"
  sha256 "d547aa6b4b8c113e9c88d6d5758495d71d2c5e634beff048672669bee8d4205a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa5d15b6340ce1f7925f17d50120a961f05b1bc06d8a4480eb947272333e1364"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa5d15b6340ce1f7925f17d50120a961f05b1bc06d8a4480eb947272333e1364"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa5d15b6340ce1f7925f17d50120a961f05b1bc06d8a4480eb947272333e1364"
    sha256 cellar: :any_skip_relocation, sonoma:         "fa5d15b6340ce1f7925f17d50120a961f05b1bc06d8a4480eb947272333e1364"
    sha256 cellar: :any_skip_relocation, ventura:        "fa5d15b6340ce1f7925f17d50120a961f05b1bc06d8a4480eb947272333e1364"
    sha256 cellar: :any_skip_relocation, monterey:       "fa5d15b6340ce1f7925f17d50120a961f05b1bc06d8a4480eb947272333e1364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2c34db21f37e4690f16349ae64e53014b819990439c30ea3d1b5da2de844101"
  end

  depends_on "node"

  resource "babel-cli" do
    url "https://registry.npmjs.org/@babel/cli/-/cli-7.23.4.tgz"
    sha256 "d68b7484904de1c6b3057ea473d39e9c0224c1f9300f73947985e19255f5e873"
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