require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.78.0.tgz"
  sha256 "43e3da3397e580fade8385fdbcb0fddb0c0c73447e10deb9b56df1f6ed7cfead"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b0075abd31a4dd6c7338591c52c88e7735b0f405ee404c2405e6ad5b3c94e42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b0075abd31a4dd6c7338591c52c88e7735b0f405ee404c2405e6ad5b3c94e42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b0075abd31a4dd6c7338591c52c88e7735b0f405ee404c2405e6ad5b3c94e42"
    sha256 cellar: :any_skip_relocation, ventura:        "5a01f9c8360e4156df9916765d411ff99508807071e81a0e3d7c44114c3a6e3f"
    sha256 cellar: :any_skip_relocation, monterey:       "5a01f9c8360e4156df9916765d411ff99508807071e81a0e3d7c44114c3a6e3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a01f9c8360e4156df9916765d411ff99508807071e81a0e3d7c44114c3a6e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b0075abd31a4dd6c7338591c52c88e7735b0f405ee404c2405e6ad5b3c94e42"
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