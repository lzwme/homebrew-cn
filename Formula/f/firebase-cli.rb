require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.8.1.tgz"
  sha256 "a7b7836d09d1de35ee1f60fa0df9ba343ded36a622df48798a9bfff05b5eb24e"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bfa24df9ec429bae9c47566795627ee2a79b3e262c1fafb44d9713bc157dc05"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b2857a807d08a21349f301e3926ea5fb3eb2dcb22c2d376f6a511e9edd320fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7df7277104922dc45e994200260d7bafe12781fe5145b3e66a71c88bcce71a12"
    sha256                               sonoma:         "63f25afe4868fb7258280afde5f2855114ecb20268c9cf91789a211610be6acf"
    sha256                               ventura:        "98a99f9e7fa5385b85b96392f9d301b46c882438eb16ca4c4fad334c8961e731"
    sha256                               monterey:       "786cdf289119aa4f78db0cb1376d5693163823d77372aa533d55b5ee95767e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "232fad0bfb052952537be31ba603803cf209b5b3ca513183b09627481345cfc6"
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