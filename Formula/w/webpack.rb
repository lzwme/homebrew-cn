require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https:webpack.js.org"
  url "https:registry.npmjs.orgwebpack-webpack-5.98.0.tgz"
  sha256 "abd3a2b6e5b0a9bd92ff8d89faf11ae0cc29697768e239936cf2f6b613ae9cff"
  license "MIT"
  head "https:github.comwebpackwebpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2bb12aec50e5582fd19fcaeac75d842fa903d6d231ab25c1b05edfc00f4f8711"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bb12aec50e5582fd19fcaeac75d842fa903d6d231ab25c1b05edfc00f4f8711"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2bb12aec50e5582fd19fcaeac75d842fa903d6d231ab25c1b05edfc00f4f8711"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae5fbd970bf08391801be99e67b0ef1d819d0aef8a03490ea6e296b05dbe4967"
    sha256 cellar: :any_skip_relocation, ventura:       "ae5fbd970bf08391801be99e67b0ef1d819d0aef8a03490ea6e296b05dbe4967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ec09e9d43ab5d566f1233b9b354083811df5d60b8d75b71135e3f8d4b09019a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2bb12aec50e5582fd19fcaeac75d842fa903d6d231ab25c1b05edfc00f4f8711"
  end

  depends_on "node"

  resource "webpack-cli" do
    url "https:registry.npmjs.orgwebpack-cli-webpack-cli-6.0.1.tgz"
    sha256 "f407788079854b0d48fb750da496c59cf00762dce3731520a4b375a377dec183"
  end

  def install
    (buildpath"node_moduleswebpack").install Dir["*"]
    buildpath.install resource("webpack-cli")

    cd buildpath"node_moduleswebpack" do
      system "npm", "install", *std_npm_args(prefix: false), "--force"
    end

    # declare webpack as a bundledDependency of webpack-cli
    pkg_json = JSON.parse(File.read("package.json"))
    pkg_json["dependencies"]["webpack"] = version
    pkg_json["bundleDependencies"] = ["webpack"]
    File.write("package.json", JSON.pretty_generate(pkg_json))

    system "npm", "install", *std_npm_args

    bin.install_symlink libexec.glob("bin*")
    bin.install_symlink libexec"binwebpack-cli" => "webpack"
  end

  test do
    (testpath"index.js").write <<~JS
      function component() {
        const element = document.createElement('div');
        element.innerHTML = 'Hello webpack';
        return element;
      }

      document.body.appendChild(component());
    JS

    system bin"webpack", "bundle", "--mode=production", testpath"index.js"
    assert_match 'const e=document.createElement("div");', (testpath"distmain.js").read
  end
end