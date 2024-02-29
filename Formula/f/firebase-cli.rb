require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.4.0.tgz"
  sha256 "1dca48050fe880a6375af90e0bc0cf462482483f16747057e47fcaa36b1d86ad"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3d032ac32fb289c23c74b105292efb6aef6e2cccdce68f46cf99d25d2a6118ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3d032ac32fb289c23c74b105292efb6aef6e2cccdce68f46cf99d25d2a6118ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3d032ac32fb289c23c74b105292efb6aef6e2cccdce68f46cf99d25d2a6118ab"
    sha256 cellar: :any_skip_relocation, sonoma:         "47d1ca8d3624bdde8a0bf45f046e8868e6bc1e04ab624c743901254a2c8ebab6"
    sha256 cellar: :any_skip_relocation, ventura:        "47d1ca8d3624bdde8a0bf45f046e8868e6bc1e04ab624c743901254a2c8ebab6"
    sha256 cellar: :any_skip_relocation, monterey:       "47d1ca8d3624bdde8a0bf45f046e8868e6bc1e04ab624c743901254a2c8ebab6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "33e2432991a9609be032deb8f037d0441f866d3a04bdb90d11328f467e1c4b2c"
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