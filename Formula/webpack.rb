require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.77.0.tgz"
  sha256 "66aa68ba84eef30c18d230ce846d5f2289db05b18caf4a5e88d032935b67a833"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9564d57bc6b0ab8934509e22da045112950272101dc2f2c7c6e2dc31dbc6f7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9564d57bc6b0ab8934509e22da045112950272101dc2f2c7c6e2dc31dbc6f7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9564d57bc6b0ab8934509e22da045112950272101dc2f2c7c6e2dc31dbc6f7c"
    sha256 cellar: :any_skip_relocation, ventura:        "aa2eeb3000ff7754ac59a8b9c0f012d92479b56be6b7ffebdd260b6a279cabb7"
    sha256 cellar: :any_skip_relocation, monterey:       "aa2eeb3000ff7754ac59a8b9c0f012d92479b56be6b7ffebdd260b6a279cabb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa2eeb3000ff7754ac59a8b9c0f012d92479b56be6b7ffebdd260b6a279cabb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9564d57bc6b0ab8934509e22da045112950272101dc2f2c7c6e2dc31dbc6f7c"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.0.1.tgz"
    sha256 "960a4dc593cea909c9a0f050d2e485291347e8e1de9e72c186995195ba9169ba"
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