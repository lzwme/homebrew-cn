require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.5.0.tgz"
  sha256 "902b5875c255ff6e35c029b30c257fb40e79195538850f032b3731c38f3d28c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cfd628b4ade811476587b5466710adfaf6c13dd37d01b891df0090733d9a28e3"
    sha256 cellar: :any,                 arm64_ventura:  "cfd628b4ade811476587b5466710adfaf6c13dd37d01b891df0090733d9a28e3"
    sha256 cellar: :any,                 arm64_monterey: "cfd628b4ade811476587b5466710adfaf6c13dd37d01b891df0090733d9a28e3"
    sha256 cellar: :any,                 sonoma:         "4ef084bc109755e9c7921014f3ee9e317e7753d281c552e12729e19c10b8eb07"
    sha256 cellar: :any,                 ventura:        "4ef084bc109755e9c7921014f3ee9e317e7753d281c552e12729e19c10b8eb07"
    sha256 cellar: :any,                 monterey:       "4ef084bc109755e9c7921014f3ee9e317e7753d281c552e12729e19c10b8eb07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bb7b967727ee4a1d9ca633efdfe15ec877446bdd85772a0d2c79ed631d849a0"
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