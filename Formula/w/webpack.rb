require "languagenode"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https:webpack.js.org"
  url "https:registry.npmjs.orgwebpack-webpack-5.90.0.tgz"
  sha256 "b6f84cba2e7896ff3515e43b921209911fd80ced990f32492be0f8dc343dc083"
  license "MIT"
  head "https:github.comwebpackwebpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c034ffa229293c5a33a6039feb0fa6b6e31db3e96875dcbd35281bbe781bd5d1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c034ffa229293c5a33a6039feb0fa6b6e31db3e96875dcbd35281bbe781bd5d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c034ffa229293c5a33a6039feb0fa6b6e31db3e96875dcbd35281bbe781bd5d1"
    sha256 cellar: :any_skip_relocation, sonoma:         "8bf140968273e969d9350b0731a28d2354ff8a88e9eb1477c26baaa4c4579811"
    sha256 cellar: :any_skip_relocation, ventura:        "8bf140968273e969d9350b0731a28d2354ff8a88e9eb1477c26baaa4c4579811"
    sha256 cellar: :any_skip_relocation, monterey:       "8bf140968273e969d9350b0731a28d2354ff8a88e9eb1477c26baaa4c4579811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c034ffa229293c5a33a6039feb0fa6b6e31db3e96875dcbd35281bbe781bd5d1"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https:registry.npmjs.orgwebpack-cli-webpack-cli-5.1.4.tgz"
    sha256 "0d5484af2d1547607f8cac9133431cc175c702ea9bffdf6eb446cc1f492da2ac"
  end

  def install
    (buildpath"node_moduleswebpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath"node_moduleswebpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec"binwebpack-cli"
    bin.install_symlink libexec"binwebpack-cli" => "webpack"

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath"index.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin"webpack", "bundle", "--mode", "production", "--entry", testpath"index.js"
    assert_match "const e=document.createElement(\"div\");", File.read(testpath"distmain.js")
  end
end