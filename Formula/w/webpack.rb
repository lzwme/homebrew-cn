require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.101.1.tgz"
  sha256 "2be80b52d1d5c1bb49cb878e39519c9fbebd7780859f9375a7eda42902d5b0d9"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a87ac10855ba697e19935a171699b3f9534c09dcc52b4947052c0dc76ccd7817"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a87ac10855ba697e19935a171699b3f9534c09dcc52b4947052c0dc76ccd7817"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a87ac10855ba697e19935a171699b3f9534c09dcc52b4947052c0dc76ccd7817"
    sha256 cellar: :any_skip_relocation, sonoma:        "413a016b6f95de49d447c036d6429a7bb86a31fce9591324e604665782e91422"
    sha256 cellar: :any_skip_relocation, ventura:       "413a016b6f95de49d447c036d6429a7bb86a31fce9591324e604665782e91422"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a87ac10855ba697e19935a171699b3f9534c09dcc52b4947052c0dc76ccd7817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a87ac10855ba697e19935a171699b3f9534c09dcc52b4947052c0dc76ccd7817"
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