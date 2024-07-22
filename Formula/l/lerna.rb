require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-8.1.7.tgz"
  sha256 "63608afc2f29b798f35b7b8acfd8ae21846d16cfe5467baae1479414e0a91080"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "47bf26dfc54078e6b02add5c53ecc876c04a97ac6d5f18c0c49f04edbe1b6da3"
    sha256 cellar: :any,                 arm64_ventura:  "47bf26dfc54078e6b02add5c53ecc876c04a97ac6d5f18c0c49f04edbe1b6da3"
    sha256 cellar: :any,                 arm64_monterey: "47bf26dfc54078e6b02add5c53ecc876c04a97ac6d5f18c0c49f04edbe1b6da3"
    sha256 cellar: :any,                 sonoma:         "c977e5b362a5602513c93ebab36007828bf45a1174e76e855423a0de3cf48389"
    sha256 cellar: :any,                 ventura:        "c977e5b362a5602513c93ebab36007828bf45a1174e76e855423a0de3cf48389"
    sha256 cellar: :any,                 monterey:       "c977e5b362a5602513c93ebab36007828bf45a1174e76e855423a0de3cf48389"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa2321bc39872469ccea2b2b0194bc1ccbc43ffe2dc29e78ed012276f40ecb6e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end