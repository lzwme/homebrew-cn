require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.0.1.tgz"
  sha256 "3763cd0f62a5ff93d62f0bff3821dfc8d7aea1fb0bfcd823431d4b9a57113ec7"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "0705ca7aed882701a3a2815d465a0729c0bacffc05fa28daa3e80096fb24303f"
    sha256                               arm64_monterey: "99ff465e03fc16edd9ae22422435d18a934fa0dc7b6534924613861a57c3bf87"
    sha256                               arm64_big_sur:  "0651451ca2f196c650ebadd8073e94590ad7466d5dd0d280d2111d1e1641fb8c"
    sha256                               ventura:        "ffb18add94feb5ccae2eff3460d0e6419a553e3611ebbef325fcd52ac0083c20"
    sha256                               monterey:       "4a6a24e9092bfbdb1f916e2f8b4c7b7c10929cec52c92fbb0947c205a42bfc8e"
    sha256                               big_sur:        "2b71d0342ca9e13a857d3e206f62c5c2442743540f90399146f0e6e83af27d44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2ca6cafef23eb9876f2b3082a78408f397bc03c90a28bd2b061dd27cb7e5f90"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end