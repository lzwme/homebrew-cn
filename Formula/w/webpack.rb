require "json"

class Webpack < Formula
  desc "Bundler for JavaScript and friends"
  homepage "https:webpack.js.org"
  url "https:registry.npmjs.orgwebpack-webpack-5.99.7.tgz"
  sha256 "2a3a2f1b361571e912cb6311e896d7684b65874a63c0c92254e81ceb9dfc6575"
  license "MIT"
  head "https:github.comwebpackwebpack.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4520ab012a95736559b0b0297d17cfa8e5e49efade84adda3b2f15497a9b5bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4520ab012a95736559b0b0297d17cfa8e5e49efade84adda3b2f15497a9b5bf"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c4520ab012a95736559b0b0297d17cfa8e5e49efade84adda3b2f15497a9b5bf"
    sha256 cellar: :any_skip_relocation, sonoma:        "220ada77a18d66b2299667d102a1cb3176d2f3a899b2bcf72d30e6e240960b01"
    sha256 cellar: :any_skip_relocation, ventura:       "220ada77a18d66b2299667d102a1cb3176d2f3a899b2bcf72d30e6e240960b01"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4520ab012a95736559b0b0297d17cfa8e5e49efade84adda3b2f15497a9b5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4520ab012a95736559b0b0297d17cfa8e5e49efade84adda3b2f15497a9b5bf"
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