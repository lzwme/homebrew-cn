class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.3.6.tgz"
  sha256 "f8dd2afc546b0481044d4a8419602eb25a11163a0b74b5196137a173e7f20fa7"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "4fbd6531a7f705e7b75c17ab311eb0bb839bc6377d86ff82baf5f75440824fbb"
    sha256                               arm64_sonoma:  "db3a4d7b1dc1a9089d7216dd790330d3f7531eb250e542ec00a2c979a590741a"
    sha256                               arm64_ventura: "7b54eddbcca9f458df2fb1bcfaa6f412573cc46c77f4d6c1f28e46de29d84b67"
    sha256                               sonoma:        "a9f0fda9666e9bee27664b4a07513b48bc7ad6110ee6fb4f2482eee1e00e9050"
    sha256                               ventura:       "df4292f576425448b71a229ffef4f35d6cab13bbed9c38301934bd1815126287"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ad6680b27fe51714ca9a89d52b6756373632baffd8f251efc373e880feb74d48"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}mongosh \"mongodb:0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}mongosh --smokeTests 2>&1")
  end
end