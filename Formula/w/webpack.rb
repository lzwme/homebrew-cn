require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.100.2.tgz"
  sha256 "d41c866dc6186080478eab2b9c43b269234a332dcfbb9cbfb8c8158e7928ae04"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "71a2718a0ddaf60c27063f02b53147e570bc5d6ba52aac5ef5650193e55eb1f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71a2718a0ddaf60c27063f02b53147e570bc5d6ba52aac5ef5650193e55eb1f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "71a2718a0ddaf60c27063f02b53147e570bc5d6ba52aac5ef5650193e55eb1f1"
    sha256 cellar: :any_skip_relocation, sonoma:        "db5dd6724244d463544507ba28466460205c364168f4376e5cf764ad7147d3b7"
    sha256 cellar: :any_skip_relocation, ventura:       "db5dd6724244d463544507ba28466460205c364168f4376e5cf764ad7147d3b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71a2718a0ddaf60c27063f02b53147e570bc5d6ba52aac5ef5650193e55eb1f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71a2718a0ddaf60c27063f02b53147e570bc5d6ba52aac5ef5650193e55eb1f1"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-6.0.1.tgz"
    sha256 "f407788079854b0d48fb750da496c59cf00762dce3731520a4b375a377dec183"
  end

  def install
    (buildpath/"node_modules/webpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath/"node_modules/webpack" do
      system "npm", "install", *std_npm_args(prefix: false), "--force"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin/*")
    bin.install_symlink libexec/"bin/webpack-cli" => "webpack"
  end

  test do
    (testpath/"index.js").write <<~JS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello webpack';
        return element;
      }

      document.body.appendChild(component());
    JS

    system bin/"webpack", "bundle", "--mode=production", testpath/"index.js"
    assert_match 'const e=document.createElement("div");', (testpath/"dist/main.js").read
  end
end