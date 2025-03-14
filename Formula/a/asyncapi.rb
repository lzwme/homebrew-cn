class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-2.16.9.tgz"
  sha256 "9de0a3c17817d11ede9c1aa71337abfeeeca9155609eaa64fabc3ccdba7a558c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "283b7f0ef0418c38ddaf81ce5a713a1923e067bd057036d177a8fcec3314680d"
    sha256 cellar: :any,                 arm64_sonoma:  "283b7f0ef0418c38ddaf81ce5a713a1923e067bd057036d177a8fcec3314680d"
    sha256 cellar: :any,                 arm64_ventura: "283b7f0ef0418c38ddaf81ce5a713a1923e067bd057036d177a8fcec3314680d"
    sha256 cellar: :any,                 sonoma:        "68e8526ff355ee0ef8d7c7d4ca0ecf7936c759c84acb730e41059d050a6049b4"
    sha256 cellar: :any,                 ventura:       "68e8526ff355ee0ef8d7c7d4ca0ecf7936c759c84acb730e41059d050a6049b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c431dd0da9fa5bc0d31b23ecbe5164d7507148cfab039d10ea650c378647f01"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]

    # Cleanup .pnpm folder
    node_modules = libexec"libnode_modules@asyncapiclinode_modules"
    rm_r (node_modules"@asyncapistudiobuildstandalonenode_modules.pnpm") if OS.linux?
  end

  test do
    system bin"asyncapi", "new", "file", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_path_exists testpath"asyncapi.yml", "AsyncAPI file was not created"
  end
end