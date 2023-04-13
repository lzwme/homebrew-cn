require "language/node"
require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https://webpack.js.org/"
  url "https://registry.npmjs.org/webpack/-/webpack-5.79.0.tgz"
  sha256 "a4a27c5594e0e6557a9a666d419f2579d58dcd171264c7d923d4b1ecf144d134"
  license "MIT"
  head "https://github.com/webpack/webpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "966b0acb9c78f4182ca657f143c6a931a241879ac06d2ff8e45134862374956e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "966b0acb9c78f4182ca657f143c6a931a241879ac06d2ff8e45134862374956e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "966b0acb9c78f4182ca657f143c6a931a241879ac06d2ff8e45134862374956e"
    sha256 cellar: :any_skip_relocation, ventura:        "aa3e7c9633d548cf7f4e2f92ea56d8b7f9cf1bcaf91a7540418b97f4953adb15"
    sha256 cellar: :any_skip_relocation, monterey:       "aa3e7c9633d548cf7f4e2f92ea56d8b7f9cf1bcaf91a7540418b97f4953adb15"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa3e7c9633d548cf7f4e2f92ea56d8b7f9cf1bcaf91a7540418b97f4953adb15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "966b0acb9c78f4182ca657f143c6a931a241879ac06d2ff8e45134862374956e"
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