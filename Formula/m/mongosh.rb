require "languagenode"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.2.10.tgz"
  sha256 "ce4649f6109fdf8c9b436e63760f193936e4660b96b25f874516e6a5f5c19ef7"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "b3689df4f9bcace3a94d64ecbd0012bfe87748462146ffcbb9f71b3887196c91"
    sha256                               arm64_ventura:  "22014132e4aace9e4f6ec12a1bd9e97bc4e5b38c505af1e7dc415ef101fe61a4"
    sha256                               arm64_monterey: "4c836947ba3da55a5ca0fde902a8a0a10317844f51ca4bf6af5e815621f4a206"
    sha256                               sonoma:         "9b8d8b3e74a951a3d3ec857a33edd810d2fb82cb0c98260925fe8cd267bf8c72"
    sha256                               ventura:        "42eb15ad3708abe92153cf174a9b81099314d029b3611b80e8a4879410958fbc"
    sha256                               monterey:       "6da955cdb8d48eb9a0e6114cb0103b0e661c150db528edb3e3b1e0dcd174c858"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ee0f625c1c6955cdb5e242c15db7922dae9c4f6b5c279ff98b3784ed3e8a898"
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