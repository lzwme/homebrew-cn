require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.84.1.tgz"
  sha256 "b7a09ef36895b7f5fe7724092a13bd88377ff42dbd306d53b2ace2d37deb4dd3"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "84921af04c761f370e8aeca528c080ddb07b4b805a08c686bc5dc845edf07e29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84921af04c761f370e8aeca528c080ddb07b4b805a08c686bc5dc845edf07e29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84921af04c761f370e8aeca528c080ddb07b4b805a08c686bc5dc845edf07e29"
    sha256 cellar: :any_skip_relocation, ventura:        "9636d8464936c6ba0c1fa62da7ebcdaf40b91e2d91b3d6dbdc8bf321e5d568ff"
    sha256 cellar: :any_skip_relocation, monterey:       "9636d8464936c6ba0c1fa62da7ebcdaf40b91e2d91b3d6dbdc8bf321e5d568ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "9636d8464936c6ba0c1fa62da7ebcdaf40b91e2d91b3d6dbdc8bf321e5d568ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84921af04c761f370e8aeca528c080ddb07b4b805a08c686bc5dc845edf07e29"
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