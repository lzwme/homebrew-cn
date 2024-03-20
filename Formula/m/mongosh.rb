require "languagenode"

class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https:github.commongodb-jsmongosh#readme"
  url "https:registry.npmjs.org@mongoshcli-repl-cli-repl-2.2.1.tgz"
  sha256 "345e6900ed5653cf925b62c2219905034a5c07f156a79c29ae7895a445b03698"
  license "Apache-2.0"

  bottle do
    sha256                               arm64_sonoma:   "aa3be0f24c8b1e0d92a34010353796e2ff8ca1550c0c27aef66b5686fd7e3b15"
    sha256                               arm64_ventura:  "453a73b9c54389d494fdc7ac1e3a609306e752612d2ea61d8674018bfc8cdedb"
    sha256                               arm64_monterey: "c59913de5ce04c39d23551a7a3eba183888a76db541c315afe3f2f12f281be26"
    sha256                               sonoma:         "f3bf822fc7d4667a7609c89fdf042bbd4c98aa85e771f8d18458378eea5aaa6a"
    sha256                               ventura:        "9e85aa4f2e0351d49118e43f5bc45164be4540e6c6eff6a8aff89c864fc6ec31"
    sha256                               monterey:       "28e1633cb79e9a329da7bd2df6bf50189ae9d9d48b039a5d9e0900e411292ff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf1a4276ee85d98feffa87f39069371336b5c24ffe7d7235ded8eaa95270178b"
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