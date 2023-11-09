require "language/node"

class SnykCli < Formula
  desc "Scans and monitors projects for security vulnerabilities"
  homepage "https://snyk.io"
  url "https://registry.npmjs.org/snyk/-/snyk-1.1242.0.tgz"
  sha256 "5d220676acf3a90c7eab836ae0ee0908f0b0872bcae6e07874c28a91280a2e09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aaae8f51456e84c0cfa129d4c78826740340809e97673556ff2a48befa609ad0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f59f868d25325ceb04359490bb3fcf0e6557b18b00c5238654bc3dbc90f4a442"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddb20fbe91a54d0435a115355e1f446753f3ee334c9eedc430d61b3f3f956df9"
    sha256 cellar: :any_skip_relocation, sonoma:         "709bb99f4aa6ad52ad49836773c44d1233ee30bad92f313ca3a6920ccf47bee4"
    sha256 cellar: :any_skip_relocation, ventura:        "93be4a9b8f2efb8fb47633a3519f54f6d2ce38be4595248b833146fcdd9fce95"
    sha256 cellar: :any_skip_relocation, monterey:       "7b2f8279584fcf5a6b67ca54b51b8df34d8187ab76544626278b3abcc0f8251e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0465e493ce944958ff46134177d0cee7a0005fcd5febb2cbb336617eb6a6a707"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/snyk version")

    output = shell_output("#{bin}/snyk auth homebrew", 2)
    assert_match "Authentication failed. Please check the API token on https://snyk.io", output
  end
end