require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.24.0.tgz"
  sha256 "1c1c2ef32d4cf300e8eff2634fdd9645fa28c726fea019ebe1f781939edc9c2e"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "8ed09430890c48a9e662279c757000c0a40c530b43687aaf99b4512ddae9eb9a"
    sha256                               arm64_monterey: "142d20d4975f884da2aa393f55dbbf9da10dcdbd2babb66968410d5cfe70c8e0"
    sha256                               arm64_big_sur:  "4dcaa11d034902b11141ceed328e15f817fb4028b34ca34c391dcaeadc8337cb"
    sha256 cellar: :any_skip_relocation, ventura:        "98ed18c0ff11792a2288ab60349a2795c2e72cacd0e5d8d2d1da0959cb0ac20a"
    sha256 cellar: :any_skip_relocation, monterey:       "98ed18c0ff11792a2288ab60349a2795c2e72cacd0e5d8d2d1da0959cb0ac20a"
    sha256 cellar: :any_skip_relocation, big_sur:        "98ed18c0ff11792a2288ab60349a2795c2e72cacd0e5d8d2d1da0959cb0ac20a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "165958f985a422fe7ed0fe024c6e0a892f1249c5c4d3d4c6b68f261e2c9a2f85"
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