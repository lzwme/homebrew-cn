require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.2.28.tgz"
  sha256 "e659a47aabbff9cb5468bf405835dd0fe4d559bac45eee650650469ac9f69bbf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "81df0691a2b513742f79457eebdaaeb9be8370f103396e1eca23ac8c0eae05dd"
    sha256 cellar: :any,                 arm64_ventura:  "81df0691a2b513742f79457eebdaaeb9be8370f103396e1eca23ac8c0eae05dd"
    sha256 cellar: :any,                 arm64_monterey: "81df0691a2b513742f79457eebdaaeb9be8370f103396e1eca23ac8c0eae05dd"
    sha256 cellar: :any,                 sonoma:         "2530c45b5ccb1796cfb1063477786377c0301865c45e8f70ba3f0d4c72793034"
    sha256 cellar: :any,                 ventura:        "2530c45b5ccb1796cfb1063477786377c0301865c45e8f70ba3f0d4c72793034"
    sha256 cellar: :any,                 monterey:       "2530c45b5ccb1796cfb1063477786377c0301865c45e8f70ba3f0d4c72793034"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f580289e452888b0ee6c443b6dbb88140b9868177073f279ef0e884b766197ed"
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