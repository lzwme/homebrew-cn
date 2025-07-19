class Mongosh < Formula
  desc "MongoDB Shell to connect, configure, query, and work with your MongoDB database"
  homepage "https://github.com/mongodb-js/mongosh"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-2.5.6.tgz"
  sha256 "9219e501b421c24c93e592cb3942db3956d5854b590a6536a2a32d3164ac404a"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256                               arm64_sequoia: "e777a24ec6b1f21f13c4378016af6fc7f9f367938fbb3378a00705029d953af1"
    sha256                               arm64_sonoma:  "7482fa7a528cdaea2f95993523a36b7e4ab33c179f9fdcab8eab7a4f9c590847"
    sha256                               arm64_ventura: "1c4da39bfa65e07b9e9bdd6d5b6e96c08f2f73c11e94e825fa5c9a8e24311941"
    sha256                               sonoma:        "db8fc87cfffa9c904de606335e6ee68906f0db4c788f1cd755463dea720db197"
    sha256                               ventura:       "330277da575a2eeedae3274cb0c9adf383ae3c9ea805ab4f7275778a0a9f23e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ca3d4c4bd987ac20cd661311dbc7fea59d9fa9866dc076f321f8a3ca326fb5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e356e0421f46cc7a10eea8fe1a89d6782e3941b298b957e79ea62dc1d096c89"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "ECONNREFUSED 0.0.0.0:1", shell_output("#{bin}/mongosh \"mongodb://0.0.0.0:1\" 2>&1", 1)
    assert_match "#ok#", shell_output("#{bin}/mongosh --nodb --eval \"print('#ok#')\"")
    assert_match "all tests passed", shell_output("#{bin}/mongosh --smokeTests 2>&1")
  end
end