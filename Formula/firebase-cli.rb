require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.4.7.tgz"
  sha256 "aa76d7736ff238f7d2a8b67ce7b1f8a671c794c82f26c82cab7b6bdc56e5d1d5"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9126b83b89ea4bb2580728e2bae86c0b8124aff530e3f9542193ae689fcec0a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9126b83b89ea4bb2580728e2bae86c0b8124aff530e3f9542193ae689fcec0a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9126b83b89ea4bb2580728e2bae86c0b8124aff530e3f9542193ae689fcec0a3"
    sha256 cellar: :any_skip_relocation, ventura:        "764b3eceb288f538164b73c6081fc606046aa7138d16c86218cf07df0f21d0aa"
    sha256 cellar: :any_skip_relocation, monterey:       "764b3eceb288f538164b73c6081fc606046aa7138d16c86218cf07df0f21d0aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "764b3eceb288f538164b73c6081fc606046aa7138d16c86218cf07df0f21d0aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84b814b5aed59989d9e7ce02a3384d7042251a236db7f3c23fce210262ffbbc1"
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