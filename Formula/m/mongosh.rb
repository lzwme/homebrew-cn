class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.3.7.tgz"
  sha256 "ef43c89db2efb24604debaf946a1d4e258b381dc22f7e64e34fe78bab14f9625"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "08bc3e7b40db7ad32dbd713cd2bf4a4a908b7d4645e99f955ba641c7fbb6c6d5"
    sha256                               arm64_sonoma:  "7ba962a70b86a736db3ec5542f4da76a18e1586fe560b0570c2aec9cc28a2ed3"
    sha256                               arm64_ventura: "0669d778de5dd526b2bdce3aa06cf9535eab09d8b3e28bc88f71b65c8ebf884b"
    sha256                               sonoma:        "9c998ed06abcf29dc9ce5036cf748d764cdbbc1abe46b4990004f46d78c5e6fc"
    sha256                               ventura:       "ab1e02f5be6ce47921f04fce3ed268786775c4ea222f8edc0b7f90900292c6de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec0aa248696125acef60f9adf7a2e0ae74c7f4d8441147dcef8d6c8ab053aaf1"
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