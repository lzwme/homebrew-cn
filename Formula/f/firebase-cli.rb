require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.14.2.tgz"
  sha256 "b1487005b55fbf0709d05a7d5cf256e9ef9999c8c7b30d47eb3a2c1f9bd71296"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91b57113629a61d359c22dd981032dd2ac34fc6849f49c765838566868c49500"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "91b57113629a61d359c22dd981032dd2ac34fc6849f49c765838566868c49500"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91b57113629a61d359c22dd981032dd2ac34fc6849f49c765838566868c49500"
    sha256 cellar: :any_skip_relocation, sonoma:         "ded31ff7763ca8300496ea48ad255b349376c985d21f7f4517a5c2564091d12e"
    sha256 cellar: :any_skip_relocation, ventura:        "ded31ff7763ca8300496ea48ad255b349376c985d21f7f4517a5c2564091d12e"
    sha256 cellar: :any_skip_relocation, monterey:       "54e74f05e41ed07e0157709050493175368832f889176001c2e0e3da9382291a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c5ca96a2a8e45ab3282c96b8662f8c44218e207e8d0fdb6ecaec6ab99e3dfa1"
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