require "languagenode"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.2.15.tgz"
  sha256 "544bb681fb419d83bd4e6b00bcd7ccebd0922cc84dfa7c86fb9f64c65dc9c049"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "de86e97bc451b679423b78db923ebfe24ba58f6ca12fffae7e8b1a4c750b9b55"
    sha256                               arm64_ventura:  "7a8eedb51719daf486d92b00fe5599ef357073c67afb1a950f24d51a08c00e89"
    sha256                               arm64_monterey: "e21a7fd7985081ac21ffc81f6fd47c2eaefeb7bc48b762835594fb3b4cff279e"
    sha256                               sonoma:         "395b27a7a61e2f31e182c8869330263440154916e8ee25e5ef513288b6ffd7a2"
    sha256                               ventura:        "1a033048251bf42a88f8004cdf164d7e2b46e84fdac4688b78a191bf178bca04"
    sha256                               monterey:       "62f84702270d620579a21359137a529c98fb2e63a41d71e4169ac0446efb12a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63bce246fc88857bd0fbd29eb7ac186cc26f88c6ae77a7a21f7b0d9b1cd88a68"
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