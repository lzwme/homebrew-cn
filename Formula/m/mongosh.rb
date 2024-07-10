require "languagenode"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.2.11.tgz"
  sha256 "59e0784738edfe0b177b6cc0a73e88d316826ebed8240587821a598f88930aaa"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "7be7a95a5af580645a28f2708ca6ea7809e8185a154d9d6a0331589e7d410660"
    sha256                               arm64_ventura:  "02cfc46be08ea0974189c6e3e703059d0c7e693359af1bd18b8e6e10c51fefe3"
    sha256                               arm64_monterey: "dc719e04101c2e2deb66669627488285ccc2715f4ec5a9cee25db7ed4e6912f6"
    sha256                               sonoma:         "19df6e5f722b342eccf3218db2239cacfb37e5b79c228fa25000b452aae82389"
    sha256                               ventura:        "0350e913cce8f2830a816e1854146044febb16245949b7d5bb21c6fbcbc47066"
    sha256                               monterey:       "cfca0a7ff2b0f6b7d4db4f2606617af47d8d7e82b1571ca65b88afda5afe30ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2436fcbca73140b3c2f615600598f34b2f9d40f34b83b85358a3542fb7509af"
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