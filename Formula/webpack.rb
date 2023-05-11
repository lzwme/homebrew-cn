require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.82.1.tgz"
  sha256 "ca7b077e3460e2ebbabb7e114fdd7d0785e95ed2c1a0426c20a53edddef89d34"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb6e98a181f07e34fd097aabf82dd751944ece5008710bfdb33aada9445eed8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb6e98a181f07e34fd097aabf82dd751944ece5008710bfdb33aada9445eed8c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb6e98a181f07e34fd097aabf82dd751944ece5008710bfdb33aada9445eed8c"
    sha256 cellar: :any_skip_relocation, ventura:        "9071b166f838a2e26299698e0b424a7399d099d1014e5832affb6a790314cf58"
    sha256 cellar: :any_skip_relocation, monterey:       "9071b166f838a2e26299698e0b424a7399d099d1014e5832affb6a790314cf58"
    sha256 cellar: :any_skip_relocation, big_sur:        "9071b166f838a2e26299698e0b424a7399d099d1014e5832affb6a790314cf58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb6e98a181f07e34fd097aabf82dd751944ece5008710bfdb33aada9445eed8c"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https://registry.npmjs.org/webpack-cli/-/webpack-cli-5.1.1.tgz"
    sha256 "18520352c9d65934b30a7a51334ed5a8d7b427117a712e25345f9017073284cf"
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