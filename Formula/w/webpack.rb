require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https:webpack.js.org"
  url "https:registry.npmjs.orgwebpack-webpack-5.96.1.tgz"
  sha256 "0f6b03262c764b8ed22edc182bed56ba8671b0ac272b187f2bb44e087aa4f04e"
  license "MIT"
  head "https:github.comwebpackwebpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a56adbfd19b54122450d07eade1ccb0b7036c0bbf3f913b46ee1470966796cef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a56adbfd19b54122450d07eade1ccb0b7036c0bbf3f913b46ee1470966796cef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a56adbfd19b54122450d07eade1ccb0b7036c0bbf3f913b46ee1470966796cef"
    sha256 cellar: :any_skip_relocation, sonoma:        "f406292a75bd168924df2c4d9c12764b4d07ac12e834ed8e904586ebec80204b"
    sha256 cellar: :any_skip_relocation, ventura:       "f406292a75bd168924df2c4d9c12764b4d07ac12e834ed8e904586ebec80204b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a56adbfd19b54122450d07eade1ccb0b7036c0bbf3f913b46ee1470966796cef"
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