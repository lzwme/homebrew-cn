require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https:webpack.js.org"
  url "https:registry.npmjs.orgwebpack-webpack-5.99.1.tgz"
  sha256 "0e3faf98109bff6a5685a4eaaa4f9a5371adcb6cb98aa99ed79f3a3ee609f96a"
  license "MIT"
  head "https:github.comwebpackwebpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1521d5fbdcc4352a6a3db28d06e5a6c60177e64306f77ab3d0bba11c3268ae3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1521d5fbdcc4352a6a3db28d06e5a6c60177e64306f77ab3d0bba11c3268ae3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1521d5fbdcc4352a6a3db28d06e5a6c60177e64306f77ab3d0bba11c3268ae3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef702dd07f417149b449d365a9ed3e540d4bc9456ed3e40c2b5764ceca325e0b"
    sha256 cellar: :any_skip_relocation, ventura:       "ef702dd07f417149b449d365a9ed3e540d4bc9456ed3e40c2b5764ceca325e0b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1521d5fbdcc4352a6a3db28d06e5a6c60177e64306f77ab3d0bba11c3268ae3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1521d5fbdcc4352a6a3db28d06e5a6c60177e64306f77ab3d0bba11c3268ae3e"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https:registry.npmjs.orgwebpack-cli-webpack-cli-6.0.1.tgz"
    sha256 "f407788079854b0d48fb750da496c59cf00762dce3731520a4b375a377dec183"
  end

  def install
    (buildpath"node_moduleswebpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath"node_moduleswebpack" do
      system "npm", "install", *std_npm_args(prefix: false), "--force"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin*")
    bin.install_symlink libexec"binwebpack-cli" => "webpack"
  end

  test do
    (testpath"index.js").write <<~JS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello webpack';
        return element;
      }

      document.body.appendChild(component());
    JS

    system bin"webpack", "bundle", "--mode=production", testpath"index.js"
    assert_match 'const e=document.createElement("div");', (testpath"distmain.js").read
  end
end