class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.3.3.tgz"
  sha256 "55e562c01ba25957a2a0b59273adeb6f6012a20babd9fb1f51ff686d806ac516"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sequoia: "27774756c5f72643f9f6d7d4c60078889e981681a142fdf276fa323998778887"
    sha256                               arm64_sonoma:  "5587271580f16b3e5f3958f087b48b4e1c38260f55cdc3269c4885d77a038a87"
    sha256                               arm64_ventura: "81f943f1d6dcde9584b7be6fc3af3d5a73c8718472e4340671193f08c0528a04"
    sha256                               sonoma:        "844838a7657f0a2fc83f9af5ba3b459b0fb1325825313e208f06f424e9498173"
    sha256                               ventura:       "9bb8d343960b62e85a40c89ffb9e32a42982b67db6bca6a1a71d16210949cb48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc28d067301fafec291a347085c7df1c8594ecf83c0a4705090aaf373374926f"
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