require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.108.1.tgz"
  sha256 "2a37258ef2d49be353864ee1893ca145986496fe910ed18ef6338258c6958f12"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6c784809e69fb2fb6fda7b279aad4d908e6372d59d193902d4d3a9008fe57a31"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-7.1.0.tgz"
    sha256 "ce0f6c8da92399001607861232e9a7523469b200ae4585c730807c1a9db9cc78"
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