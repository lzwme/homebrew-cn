require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.83.1.tgz"
  sha256 "9df32f9d4cfcc72cb117884a91328f03db9b51c0cbf4fd14d6a455cf63991c34"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e0a657e89d8c858efba4581972134f120f4c56ea66c157f83aef2459eba6f46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3e0a657e89d8c858efba4581972134f120f4c56ea66c157f83aef2459eba6f46"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e0a657e89d8c858efba4581972134f120f4c56ea66c157f83aef2459eba6f46"
    sha256 cellar: :any_skip_relocation, ventura:        "ae9d96fd3e7693e5d37064dda36652b4fbe8c11af1fddb70a755a52ce30f6bd0"
    sha256 cellar: :any_skip_relocation, monterey:       "ae9d96fd3e7693e5d37064dda36652b4fbe8c11af1fddb70a755a52ce30f6bd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae9d96fd3e7693e5d37064dda36652b4fbe8c11af1fddb70a755a52ce30f6bd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e0a657e89d8c858efba4581972134f120f4c56ea66c157f83aef2459eba6f46"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.1.1.tgz"
    sha256 "18520352c9d65934b30a7a51334ed5a8d7b427117a712e25345f9017073284cf"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *Language::Node.local_npm_install_args, "--legacy-peer-deps"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *Language::Node.std_npm_install_args(libexec)

    bin.install_symlink libexec/"bin/webpack-cli"
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    (testpath/"index.js").write <<~EOS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello' + ' ' + 'webpack';
        return element;
      }

      document.body.appendChild(component());
    EOS

    system bin/"webpack", "bundle", "--mode", "production", "--entry", testpath/"index.js"
    assert_match "const e=document.createElement(\"div\");", File.read(testpath/"dist/main.js")
  end
end