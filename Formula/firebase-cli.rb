require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.4.3.tgz"
  sha256 "3adc0b516f016619675ff1b0f6345bbfa8a10dc00818222ac8b52787646b3804"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "d44a45f5a29ef25457b4b795d13b8dc54d366489b5fd9066d2ce63503ae0233e"
    sha256                               arm64_monterey: "636f23d90c0189670228fa1fa518e3195c796e9a996bcd4cc7316ffeca5c1fa2"
    sha256                               arm64_big_sur:  "b69b2d04b1549021a5bcc23974bcfd12ac239daa14be67c8827b86eec3deed9c"
    sha256 cellar: :any_skip_relocation, ventura:        "fad920cb5e1c451b6f7cb83e4b6db14fc81cfa428c6d49f5bfe311e6f7abca8b"
    sha256 cellar: :any_skip_relocation, monterey:       "fad920cb5e1c451b6f7cb83e4b6db14fc81cfa428c6d49f5bfe311e6f7abca8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "fad920cb5e1c451b6f7cb83e4b6db14fc81cfa428c6d49f5bfe311e6f7abca8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45cc46bdd53f87b6cbea12cc206df7682953c359c5cf3a5b437a085ccaf9f2dd"
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