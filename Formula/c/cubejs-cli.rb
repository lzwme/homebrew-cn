require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.35.6.tgz"
  sha256 "de8b615442b7656f4b46d8a017da84a5941174d2e7ba2c85edf71be461325554"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f8508301099a3b8532dc8588cb3deaba394b43be02ffcf835b0e419c37c7bae2"
    sha256 cellar: :any,                 arm64_ventura:  "f8508301099a3b8532dc8588cb3deaba394b43be02ffcf835b0e419c37c7bae2"
    sha256 cellar: :any,                 arm64_monterey: "f8508301099a3b8532dc8588cb3deaba394b43be02ffcf835b0e419c37c7bae2"
    sha256 cellar: :any,                 sonoma:         "189b4e88ccffcbd9c45d323ceb17e006ab6b27956ae5e355776bc568c5b97586"
    sha256 cellar: :any,                 ventura:        "189b4e88ccffcbd9c45d323ceb17e006ab6b27956ae5e355776bc568c5b97586"
    sha256 cellar: :any,                 monterey:       "189b4e88ccffcbd9c45d323ceb17e006ab6b27956ae5e355776bc568c5b97586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec6965c3b1b3a0ababfbbdf0afcaa2967139d6b87acc399889241243bbe133ce"
  end

  depends_on "node"
  uses_from_macos "zlib"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end