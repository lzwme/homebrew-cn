require "languagenode"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh#readme"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.2.3.tgz"
  sha256 "5a903dbe608b4b026df149c5c53652322de5ba393a7e9bfdcda4fab5181eb57a"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "3a4835f7bf46bfe1c8cad72903e2591e02ec51629ba472a874a5018b9e2c8c05"
    sha256                               arm64_ventura:  "12491f50d59a030e7bba782041ee52b16e766abf980f5ac50465c68fd321525b"
    sha256                               arm64_monterey: "b02a2216d33f958c97d14e7692d0d58597bb0313db12b9ba1100726dff33844c"
    sha256                               sonoma:         "12e7d23edd8ef1965426bd03f6a6b3745adca4aa4be67f774a7458e86274e491"
    sha256                               ventura:        "cfdc8443a2c0f9fa9ae4d7496c4c68f741aa22a62376e1b655a1f12369047c06"
    sha256                               monterey:       "fbbe8163ad28c7284ed602fdbf9c8999fca199bd169be06a34ac27aa11612aef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5bab899ac7cadae953973e7ddc70f065deb2fdd2df7935dbb276818408b4498"
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