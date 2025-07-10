require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.100.0.tgz"
  sha256 "44a0b2db2ef379d68105f3ca7986cf41601c4c7f7c50e8900df18865b8d477ed"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10232b274617a5a425723e9903fd29c55bfad020e7f8435869af22f28a74f152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10232b274617a5a425723e9903fd29c55bfad020e7f8435869af22f28a74f152"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "10232b274617a5a425723e9903fd29c55bfad020e7f8435869af22f28a74f152"
    sha256 cellar: :any_skip_relocation, sonoma:        "32af9bbe472dcc48298234cef5d5e1068e25229e1dc00dfb6ca5722f64b6af80"
    sha256 cellar: :any_skip_relocation, ventura:       "32af9bbe472dcc48298234cef5d5e1068e25229e1dc00dfb6ca5722f64b6af80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "10232b274617a5a425723e9903fd29c55bfad020e7f8435869af22f28a74f152"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "10232b274617a5a425723e9903fd29c55bfad020e7f8435869af22f28a74f152"
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