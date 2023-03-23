require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.25.1.tgz"
  sha256 "ca55cc5c9c20358187ee7e71018f0c801736d737faf03873b60a6783b2c19bac"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "26590922199e8612f30e443c183a8883347d9159e9126aa1c820667526bde874"
    sha256                               arm64_monterey: "0bafc6481d0ed5b50b1ff69e72ca78a99e1caa3e73b41ea97a592c2045122185"
    sha256                               arm64_big_sur:  "8c5899eac83ed60522a6e7395f9345009f878b6903b668583cb570d0fcaa6790"
    sha256 cellar: :any_skip_relocation, ventura:        "91f62b2ac9ccf12e1d3170f348fd2978529e372701641c5bce1c33d4bd2ae85d"
    sha256 cellar: :any_skip_relocation, monterey:       "91f62b2ac9ccf12e1d3170f348fd2978529e372701641c5bce1c33d4bd2ae85d"
    sha256 cellar: :any_skip_relocation, big_sur:        "91f62b2ac9ccf12e1d3170f348fd2978529e372701641c5bce1c33d4bd2ae85d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cd0b494c27ab3e6b8b51e2350d239a890ea0233e241e52545cfc807cae86f2f4"
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