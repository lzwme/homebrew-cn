require "languagenode"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.2.12.tgz"
  sha256 "7e4dd7b9b607caab6e5fd6ff246e9cf86b616a795cccab259f98041978efda69"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "a0da1e8f33850a06f3f335c7d602996634d71dfe511976d06762cd5e318f7ba7"
    sha256                               arm64_ventura:  "aaf31e578b6854d10bb556e66ef158f0069e181c693ec31c3d81ec4bef32ce4e"
    sha256                               arm64_monterey: "97b2972b51ab15666763cd2d835d1961a034fc80dd504634f991c22f778ed428"
    sha256                               sonoma:         "6218e4ee296f66e97abbdc52f9bbbb339187664390ce9f7fbd4f6bbb9c024b67"
    sha256                               ventura:        "d630d1b387951fb63b03669c3eefb0bd83d69d0428f19854f67cf857ebc6b119"
    sha256                               monterey:       "4d70a2c03a0d0c142dd81d9987fe763b44228e4dd74c409a79924d639d78d860"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afbf38a9996c5fca2f1cbff989ca30a54ad0e8e1790c0c35f52f99473421e9dc"
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