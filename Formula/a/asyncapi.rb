require "languagenode"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https:github.comasyncapicli"
  url "https:registry.npmjs.org@asyncapicli-cli-1.4.11.tgz"
  sha256 "f99e067cbec1cd6c4dadcc44dd007e2c41bf11c7a86041ee3354368471a22532"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4dadce9a581abba0e424cd11609e837bd0b3a0d05613d3f2062b942b2ad1298f"
    sha256 cellar: :any,                 arm64_ventura:  "4dadce9a581abba0e424cd11609e837bd0b3a0d05613d3f2062b942b2ad1298f"
    sha256 cellar: :any,                 arm64_monterey: "4dadce9a581abba0e424cd11609e837bd0b3a0d05613d3f2062b942b2ad1298f"
    sha256 cellar: :any,                 sonoma:         "914f4fb1b886d718aec191ab84844947315fc616c044cbcaa3a42de7c44265dd"
    sha256 cellar: :any,                 ventura:        "914f4fb1b886d718aec191ab84844947315fc616c044cbcaa3a42de7c44265dd"
    sha256 cellar: :any,                 monterey:       "914f4fb1b886d718aec191ab84844947315fc616c044cbcaa3a42de7c44265dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "506a691ff64ffebdd88ef94219b79c1b2078ebcc2f761f865823e7b9ca224167"
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