class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.3.5.tgz"
  sha256 "76947dfac25b4cc57216199c41387c31e2319fcd0b3bf0d94aef5e3b49cae975"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "14dc1bad7d6097a468636d8764ced84ba30d5cb13e2be294dcc997b76eb539f0"
    sha256                               arm64_sonoma:  "d25c730fc57f23e67d693f590a2c43a29797bddc3d9af79817bb8d7031b45503"
    sha256                               arm64_ventura: "204a29bfd5fa39a7a52b8d8b884aca945a6327535edf34c661d83278d658e36d"
    sha256                               sonoma:        "8c8a7090a6a38325951d71128241b73456de282ca02267a0f6e3df530d3f0060"
    sha256                               ventura:       "20b01c2eeab4ab02dbdf346ae005e0c804448a1712aa465087db2b0a7c3fe1f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a17ebac25a47df1aa8e0909f23702f6bb87c35010e34bc845f6cc5606d768f05"
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