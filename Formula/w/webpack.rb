require "languagenode"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https:webpack.js.org"
  url "https:registry.npmjs.orgwebpack-webpack-5.90.1.tgz"
  sha256 "49213425e073f1807dec3953ac8bf8fbf58469101f636fedc0e622430fc240dd"
  license "MIT"
  head "https:github.comwebpackwebpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "98c5723756b94ad4e76327d1324aed65655018573772d54dc3dd4113d440c71e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98c5723756b94ad4e76327d1324aed65655018573772d54dc3dd4113d440c71e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "98c5723756b94ad4e76327d1324aed65655018573772d54dc3dd4113d440c71e"
    sha256 cellar: :any_skip_relocation, sonoma:         "e7d650bf1a448bfe943cfd2d4bd46099d14d6c562621f41ec5dc45b8c3c687d4"
    sha256 cellar: :any_skip_relocation, ventura:        "e7d650bf1a448bfe943cfd2d4bd46099d14d6c562621f41ec5dc45b8c3c687d4"
    sha256 cellar: :any_skip_relocation, monterey:       "e7d650bf1a448bfe943cfd2d4bd46099d14d6c562621f41ec5dc45b8c3c687d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98c5723756b94ad4e76327d1324aed65655018573772d54dc3dd4113d440c71e"
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