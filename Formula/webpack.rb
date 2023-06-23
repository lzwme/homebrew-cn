require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.88.0.tgz"
  sha256 "833fba2ee2b05febe7197b1aafc3f73d47056cddd1b99eeae178fe20a879c382"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b69939e57452b0a16c966f1b7b28648047a2514db2f2d198e8facb92f707dcbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69939e57452b0a16c966f1b7b28648047a2514db2f2d198e8facb92f707dcbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "635e60284790da6d877c0db4b804ed034a9ecba7614d3c32e168b7debaff58cc"
    sha256 cellar: :any_skip_relocation, ventura:        "088547b3372ab027ee13ff3b6b4ce3552b764642e48e7697c272a472d0d12492"
    sha256 cellar: :any_skip_relocation, monterey:       "088547b3372ab027ee13ff3b6b4ce3552b764642e48e7697c272a472d0d12492"
    sha256 cellar: :any_skip_relocation, big_sur:        "088547b3372ab027ee13ff3b6b4ce3552b764642e48e7697c272a472d0d12492"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "635e60284790da6d877c0db4b804ed034a9ecba7614d3c32e168b7debaff58cc"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.1.4.tgz"
    sha256 "0d5484af2d1547607f8cac9133431cc175c702ea9bffdf6eb446cc1f492da2ac"
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