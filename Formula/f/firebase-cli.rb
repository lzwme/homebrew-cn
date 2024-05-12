require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.8.3.tgz"
  sha256 "9659e72d4a45e6301e7d350dd7b586f65643d4171569432833d6681934dfa15e"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7901e20aabaa8b0618004b8914542b65aa0bea54970c990759ab6d5880e3bd9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d601778cab10a0002b16f97014b5a26d0cd8a200b2b8ac3cdbb224288065a8af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72e2acd1d191932e465d376ee12ca0a20de0110d0341e7bdc14abc014159c432"
    sha256                               sonoma:         "046da79dcbea76fc5737e7d5d76da9789219895861ebf6cee0aebb6b626fe21a"
    sha256                               ventura:        "7ce07d2574637b70eaf68975912bce99077ccd28de14c3022545288caa0a2d27"
    sha256                               monterey:       "49437777490cc26086e215baba3f3d3214106a81974b4854e95fe878bbf19e6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c2e3e369fd864aca8225a5c1fe80ab1026e5fb028c55d65a79f1fa25685bca1"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test.exp").write <<~EOS
      spawn #{bin}firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end