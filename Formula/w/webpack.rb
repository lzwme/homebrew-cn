require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https:webpack.js.org"
  url "https:registry.npmjs.orgwebpack-webpack-5.94.0.tgz"
  sha256 "5dcc6331cc48e04b8540ed076d086cc22f3b544448bb2495f9dc94e6c0328bd5"
  license "MIT"
  head "https:github.comwebpackwebpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "54b395a592783677d59f2bb1f24ae6818dac794cb498664400e8b327b9648127"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b6a2547635c2a2c6ec9630d46f966021b40481f7265bd9fa920a773d49010f50"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6a2547635c2a2c6ec9630d46f966021b40481f7265bd9fa920a773d49010f50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6a2547635c2a2c6ec9630d46f966021b40481f7265bd9fa920a773d49010f50"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8e9e7c66b7315502e44179889be7e3cede222fbf996d5be9056a9dc2e12048b"
    sha256 cellar: :any_skip_relocation, ventura:        "e8e9e7c66b7315502e44179889be7e3cede222fbf996d5be9056a9dc2e12048b"
    sha256 cellar: :any_skip_relocation, monterey:       "e8e9e7c66b7315502e44179889be7e3cede222fbf996d5be9056a9dc2e12048b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6a2547635c2a2c6ec9630d46f966021b40481f7265bd9fa920a773d49010f50"
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