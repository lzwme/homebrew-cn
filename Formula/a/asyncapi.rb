require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.13.0.tgz"
  sha256 "13d7b62eda5becc4bf6db255d087c40a657c50f3c5cb7d43d5ff5ef8bb6e517e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c75f71da6b3704d1ef137007197d77b0f9b9d4c4c1273f4a636db435613e2bf1"
    sha256 cellar: :any,                 arm64_ventura:  "464f91375766bc207cab60fb711b7ac0673176759a146dc8336e0a1ecb9cfb10"
    sha256 cellar: :any,                 arm64_monterey: "1ade7de1f05c6967ce7607d582de9fe7f25966c2030115348b6f376b524073fd"
    sha256 cellar: :any,                 sonoma:         "5836c3eca37efaf2b13220da5922fd1fea151f161493e28950f67293d1090423"
    sha256 cellar: :any,                 ventura:        "4d6467995513a6f78fff7c317be8712e8ab58da1765e998412e1634bc5d1c724"
    sha256 cellar: :any,                 monterey:       "b3012bc5bbe98687552c941e814471261ce7944e82ba2a0bf9ab73a82a1fa7ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e3ec2775cd485f1ebe0e0123e69e7bde842c664de7c42378650e0304e48ee3f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end