require "language/node"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.1.1.tgz"
  sha256 "b440378b4a4c7e2badc6a66c344fc00fcd02749f8acaf9097d5fe40bf9f664e3"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "310782125c5c4a5455b3a52cc1ab85bb842e5388e6886cc498582ab10af6de34"
    sha256                               arm64_ventura:  "ece8d7c2580fe368a95dc1be2966c0574a579e3a93c251bee87d985f9ee8b92d"
    sha256                               arm64_monterey: "46fae503aa5df858979bf354804f14415f1835ff72b82a634dba3d6c054b469b"
    sha256                               sonoma:         "1b95d368b0a95571191a01e0aa04bd1e19239c741f43b4c33cbe1c33216f405c"
    sha256                               ventura:        "ceb0d5724f737bc806a059e55de95f1efa8d57439e65728e14371a189c74fc83"
    sha256                               monterey:       "721ab6c00c5ad1019ae82531cbdf2c3639094891e5bccfbb6d96b326f6c329e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4fa0db2b30b7dc15ff6d714f3e6bc673ae0649d1fa1f7e482b85bc1267fc3c33"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", PATH: "#{Formula["node"].opt_bin}:$PATH"
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end