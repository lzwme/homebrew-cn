require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.101.0.tgz"
  sha256 "308ca5aa5ad39e4c20fce043d51d9457ed33a3d86d264a6257d565d28fcccb15"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e14bd462bb101d07ba56dcf3253887638b56d9f0143de35071d151a3f673f9e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e14bd462bb101d07ba56dcf3253887638b56d9f0143de35071d151a3f673f9e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e14bd462bb101d07ba56dcf3253887638b56d9f0143de35071d151a3f673f9e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "f3deb70f1f9b7b9a9609ab2e2acc1c7ba3b2a3dd527a228568e330aebfecc547"
    sha256 cellar: :any_skip_relocation, ventura:       "f3deb70f1f9b7b9a9609ab2e2acc1c7ba3b2a3dd527a228568e330aebfecc547"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e14bd462bb101d07ba56dcf3253887638b56d9f0143de35071d151a3f673f9e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e14bd462bb101d07ba56dcf3253887638b56d9f0143de35071d151a3f673f9e1"
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