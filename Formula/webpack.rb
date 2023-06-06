require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.85.1.tgz"
  sha256 "c7c30fd35758c7fb2565635f33370fc38b1a8cf95eea8fa2e0427805b7c8e4db"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eed27927e2414404ab284ceabcd036f5eeaf0b2b4080c77fb3c63160b73eabbe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eed27927e2414404ab284ceabcd036f5eeaf0b2b4080c77fb3c63160b73eabbe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eed27927e2414404ab284ceabcd036f5eeaf0b2b4080c77fb3c63160b73eabbe"
    sha256 cellar: :any_skip_relocation, ventura:        "fa5c6b1b80f40d767d09d1fdb44e7e341978d9023dc4cffb5f902d9f29c45bd5"
    sha256 cellar: :any_skip_relocation, monterey:       "fa5c6b1b80f40d767d09d1fdb44e7e341978d9023dc4cffb5f902d9f29c45bd5"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa5c6b1b80f40d767d09d1fdb44e7e341978d9023dc4cffb5f902d9f29c45bd5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eed27927e2414404ab284ceabcd036f5eeaf0b2b4080c77fb3c63160b73eabbe"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.1.3.tgz"
    sha256 "0f814cfa5fce08b19d47dcfa535ed4f44fbadb2bcafd3fe0b8a7b2481b4b4065"
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