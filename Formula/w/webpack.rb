require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.101.2.tgz"
  sha256 "59ac6f14d5d92c03590ccd265409adb8d89544982895dbaa00442068b6594ae8"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "62703486739d0189fc2b9e14a8ccece784ce7d7e2ef3e37f5dda8b978c871f83"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62703486739d0189fc2b9e14a8ccece784ce7d7e2ef3e37f5dda8b978c871f83"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62703486739d0189fc2b9e14a8ccece784ce7d7e2ef3e37f5dda8b978c871f83"
    sha256 cellar: :any_skip_relocation, sonoma:        "62703486739d0189fc2b9e14a8ccece784ce7d7e2ef3e37f5dda8b978c871f83"
    sha256 cellar: :any_skip_relocation, ventura:       "62703486739d0189fc2b9e14a8ccece784ce7d7e2ef3e37f5dda8b978c871f83"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b439ba24f0e9ff3b6d5694e3533001680bf2732dd522ab616c0f1dc5d42e6188"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b439ba24f0e9ff3b6d5694e3533001680bf2732dd522ab616c0f1dc5d42e6188"
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