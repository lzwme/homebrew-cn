require "languagenode"

class Dicebear < Formula
  desc "CLI for DiceBear - An avatar library for designers and developers"
  homepage "https:github.comdicebeardicebear"
  url "https:registry.npmjs.orgdicebear-dicebear-7.0.3.tgz"
  sha256 "da505506f7aafd2a851a4a23456bd0e3a562ecc6856b59f3e50de42cb2523516"
  license "MIT"

  bottle do
    sha256                               arm64_sonoma:   "2db4717f73fcdfc23592edd4326237c0465c031f1326a34fd9abd72191afbc11"
    sha256                               arm64_ventura:  "00216e490e473bb850c44a3880f6539ebbdf636430119712b02ae1adb330be71"
    sha256                               arm64_monterey: "6c07db86a32965434e72bb10431ad1dc544bf0a20694ecf0012f5b65fe4abb7c"
    sha256                               sonoma:         "d319c2921de4f9ad67a9f07d8d0bed8dadd53a021f59d055fed1fe403bf3cc54"
    sha256                               ventura:        "049e99cf4664051ae1b89e5d319a52619dbece00e6f8f5892c1cf1d707eb8484"
    sha256                               monterey:       "66563142be4f3cb7a7487f46938840abff3c65fbbeadf374c49fc83793d938d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "166e4f078fe5f365d8ac1ea1be45bc4d487eead0e496977d169dbf78c9478465"
  end

  depends_on "node"

  on_linux do
    depends_on "vips"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec"libnode_modulesdicebearnode_modules"
    (node_modules"@resvgresvg-js-linux-x64-muslresvgjs.linux-x64-musl.node").unlink if OS.linux?
  end

  test do
    output = shell_output("#{bin}dicebear avataaars")
    assert_match "Avataaars by Pablo Stanley", output
    assert_predicate testpath"avataaars-0.svg", :exist?

    assert_match version.to_s, shell_output("#{bin}dicebear --version")
  end
end