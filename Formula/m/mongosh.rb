require "languagenode"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh#readme"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.1.3.tgz"
  sha256 "0c6076f6a06955b26ac1b5aca3b2ab70ea756f2d2d2fc98accd58ee75cbf7401"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "327d67a5509d7a8511e22cbe0ff1fd346a013bd64a3873d0473a738901d990d7"
    sha256                               arm64_ventura:  "7657a79641860b99c863412d11c986be6c752a57994dcc98f7d1343dd9ed415d"
    sha256                               arm64_monterey: "9f752a361a82df4df22b1d422344ede7ca12165f977e1549bce6d229fe53d91e"
    sha256                               sonoma:         "291e6386d4b8dae0ee369134fc4a987d624e7e90e87a844984ee442b63a99e5a"
    sha256                               ventura:        "00e7a35112c88d8aac33674cf9404d6f53ab3207ba40f1d5849f04866cef0f56"
    sha256                               monterey:       "f0662737fe68298b61e70ebf0c32bc3bf6112edabeb1fa4305215108055d4396"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad77812fb3f9d1005b733f67cec4aade0e6416597a711c05794d0c874f11a778"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin"mongosh").write_env_script libexec"binmongosh", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}mongosh \"mongodb:0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}mongosh --smokeTests 2>&1")
  end
end