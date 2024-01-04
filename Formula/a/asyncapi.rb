require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.2.30.tgz"
  sha256 "1c53d2534d4c90a31af5730886343e4f1b8f4f1b0d43ed14fbdea041748becbd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c4af0130b330570eaa9ec886ca129935e7503fe2ec4efc6de8a7182b9fa9d683"
    sha256 cellar: :any,                 arm64_ventura:  "c4af0130b330570eaa9ec886ca129935e7503fe2ec4efc6de8a7182b9fa9d683"
    sha256 cellar: :any,                 arm64_monterey: "c4af0130b330570eaa9ec886ca129935e7503fe2ec4efc6de8a7182b9fa9d683"
    sha256 cellar: :any,                 sonoma:         "1ece29a0159e7a3117af4650dd72aff04474d25d9f383718f921b85d35b30a28"
    sha256 cellar: :any,                 ventura:        "1ece29a0159e7a3117af4650dd72aff04474d25d9f383718f921b85d35b30a28"
    sha256 cellar: :any,                 monterey:       "1ece29a0159e7a3117af4650dd72aff04474d25d9f383718f921b85d35b30a28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf477fe327ca42aacbc6546b3082298dcfd8f9ea509e3d05e484a3e08644c2c8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec"libnode_modules@asyncapiclinode_modules"
    (node_modules"@swccore-linux-x64-muslswc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end