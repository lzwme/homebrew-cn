require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.76.3.tgz"
  sha256 "2118d91f5295d609b80289660f80943a4ba8fade3c5606ec5e9113123bc94a98"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "277f40ae76bb802c04458c17d49b387542e830662a05335dfd8dcedbc95d44d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "277f40ae76bb802c04458c17d49b387542e830662a05335dfd8dcedbc95d44d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "277f40ae76bb802c04458c17d49b387542e830662a05335dfd8dcedbc95d44d7"
    sha256 cellar: :any_skip_relocation, ventura:        "a44d667fb41d71e76d0d567af486de62e570c9e8fdb1643ca18592ea89aad75c"
    sha256 cellar: :any_skip_relocation, monterey:       "a44d667fb41d71e76d0d567af486de62e570c9e8fdb1643ca18592ea89aad75c"
    sha256 cellar: :any_skip_relocation, big_sur:        "a44d667fb41d71e76d0d567af486de62e570c9e8fdb1643ca18592ea89aad75c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "277f40ae76bb802c04458c17d49b387542e830662a05335dfd8dcedbc95d44d7"
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