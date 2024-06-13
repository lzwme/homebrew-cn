require "languagenode"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.2.6.tgz"
  sha256 "0cf3f54ecd2e3d37e669761c12de9771af1f8e32e35ba7946938f76612d92cb4"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "00b50abcf8935a05510d3e47336a0eb877c95f7027c9bf04d6e785476b9f6970"
    sha256                               arm64_ventura:  "72801f3f683a2a5e33e01a0f6bb7071476f947ea2422a76880cf237078af3948"
    sha256                               arm64_monterey: "b8e17cc2d5f7092fa7739cea62aeaae8b8ed15ab8929008c233ec1e690a4bc41"
    sha256                               sonoma:         "fc4754eaaf9248387d3841895c56b4364cf508d7ecaed034a2ef0d708449d537"
    sha256                               ventura:        "2457d334072faa6ab205575787230eb30685c1be62a1807644f2b8d3eb80003a"
    sha256                               monterey:       "3b226a233bf90883967261075ce2566c07d7e0d98ee61cd88cb934387431551d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf30b6a80dcd7314c374a5514043901cc16755a5197353da89fd2d9c2772c393"
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