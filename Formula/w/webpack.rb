require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https:webpack.js.org"
  url "https:registry.npmjs.orgwebpack-webpack-5.97.0.tgz"
  sha256 "5f9ce9cb87f49db3430030db450f33c87f54d39797649c62f0608bdbf7178015"
  license "MIT"
  head "https:github.comwebpackwebpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "52636a0c85619be22324e153ca7e43fcbe7e43791b69a00a0bea1911908253c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "52636a0c85619be22324e153ca7e43fcbe7e43791b69a00a0bea1911908253c1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "52636a0c85619be22324e153ca7e43fcbe7e43791b69a00a0bea1911908253c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5dc64be2cd8d01fb03686105f7f89391836bcf1a7dcd14930dfd5d164167ffa"
    sha256 cellar: :any_skip_relocation, ventura:       "a5dc64be2cd8d01fb03686105f7f89391836bcf1a7dcd14930dfd5d164167ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52636a0c85619be22324e153ca7e43fcbe7e43791b69a00a0bea1911908253c1"
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
      system "npm", "install", *std_npm_args(prefix: false), "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *std_npm_args

    bin.install_symlink libexec"binwebpack-cli"
    bin.install_symlink libexec"binwebpack-cli" => "webpack"

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath"index.js").write <<~JS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    JS

    system bin"webpack", "bundle", "--mode", "production", "--entry", testpath"index.js"
    assert_match "const e=document.createElement(\"div\");", File.read(testpath"distmain.js")
  end
end