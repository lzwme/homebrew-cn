require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.4.5.tgz"
  sha256 "8ea7ad365d268cf3127c4b1a143333d917674a8a6e4203774c630792e7412850"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "b8b379fc1d706b473d81a02be29547b1f6401c139cc9f0d2a3e44beb05787823"
    sha256                               arm64_monterey: "a526bf95d04b58a569cb556d3b3b53af1811a2db8b5727b1d5992bcdbc8fd7a7"
    sha256                               arm64_big_sur:  "555e4ec0e157f66c27f7439160b1665df0238176e09b47573019884af2c5210a"
    sha256 cellar: :any_skip_relocation, ventura:        "e4161df2cdc575cc72921858dbcee5e8a3c5529dbc17105ec2f1860a031cf71f"
    sha256 cellar: :any_skip_relocation, monterey:       "e4161df2cdc575cc72921858dbcee5e8a3c5529dbc17105ec2f1860a031cf71f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4161df2cdc575cc72921858dbcee5e8a3c5529dbc17105ec2f1860a031cf71f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a353b6834b43710e2530e354155e1012b8d00aa1466b907a7d8f011f73085833"
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