require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.25.2.tgz"
  sha256 "6780793e50ac49c14e004edc657d4f350b2fd9a679b1b631c1cc72e315bdc474"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "215f02b24a5f9b5cdc906b7a56a19bf18043b5ce128566d94c04f6a2cfa028db"
    sha256                               arm64_monterey: "39086e159fe7342f9e6416c5ec5be59a4f2b779f4dce315baded238de9bb023b"
    sha256                               arm64_big_sur:  "2d6daa35629964fcbce8765243ececec82b1561af53b3aff913d6e87dcb725c6"
    sha256 cellar: :any_skip_relocation, ventura:        "7538dabd70399220da1a2b7d058f2c0f61039d5d4c5e1dc3fd9088b79ac6f72e"
    sha256 cellar: :any_skip_relocation, monterey:       "7538dabd70399220da1a2b7d058f2c0f61039d5d4c5e1dc3fd9088b79ac6f72e"
    sha256 cellar: :any_skip_relocation, big_sur:        "7538dabd70399220da1a2b7d058f2c0f61039d5d4c5e1dc3fd9088b79ac6f72e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6627762a7a83613ebbd341ae54c0e25985feae99825ed13845b6ab31978977ac"
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