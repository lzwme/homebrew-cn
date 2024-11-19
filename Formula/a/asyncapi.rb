class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.10.0.tgz"
  sha256 "5dab82c4327154a2ff2d2c310fdf63af4fdec73f77be01d45a5eebd96a87d74d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "16de43ddf70b4b757e6cf51ae2905bdf99a66e45abada63479ef4684b1514d4c"
    sha256 cellar: :any,                 arm64_sonoma:  "16de43ddf70b4b757e6cf51ae2905bdf99a66e45abada63479ef4684b1514d4c"
    sha256 cellar: :any,                 arm64_ventura: "16de43ddf70b4b757e6cf51ae2905bdf99a66e45abada63479ef4684b1514d4c"
    sha256 cellar: :any,                 sonoma:        "3f82f74896c0faacbf5d694c775a17e64a449fdfd71a1ec41fe8edfbbc4573f3"
    sha256 cellar: :any,                 ventura:       "3f82f74896c0faacbf5d694c775a17e64a449fdfd71a1ec41fe8edfbbc4573f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7f35ad0e3e2eecdd270ebdfc080798ef45365919aa8ee591ae977074f0ee97d2"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end