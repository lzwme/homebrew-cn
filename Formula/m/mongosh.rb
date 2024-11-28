class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.3.4.tgz"
  sha256 "3af12ba49f4a3ac239608b013a0cfb05a4f4391e1820261e822c4c6502649c07"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "e6d76b96884fea12763cd7c9af40e6578a5b52285d3e6b7edce8911b5f9be404"
    sha256                               arm64_sonoma:  "5b614641adca4b85a1900921aa895a90fc5586b205a4b11242c09a2c2d24f8a1"
    sha256                               arm64_ventura: "5bcc1b3aba3f961aa50ab5ee99640de78e2cd3130ea729d7ab6803e81f8b2750"
    sha256                               sonoma:        "351edb557ffa7cd79ce8aa2c5f49a034038a893613fe40ebd5fef8d4ae20a425"
    sha256                               ventura:       "74b9bed7da244fa1ab239d808d67424fdfc1b11441210701cc28646947790ca6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "979a27d83a5a932b58449ed4426a71f67fb638d3fce4b6a74ce1a536759ac796"
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