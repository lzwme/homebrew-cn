require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.30.0.tgz"
  sha256 "cb01ecc4a1af8c97ee63829b6d2175f28245e7506a9d777a5e13b58b5a26eaa3"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "0dc8af109b2ae92b3553a64e6836cbeda45324c9a03103a4a5b4d66bd0a38a3e"
    sha256                               arm64_monterey: "50d76aff6f6f6ba46aff3f200ad9db7de9faadee7030703ca9bdd417ef099f7f"
    sha256                               arm64_big_sur:  "e6f2b0ec1a2a73953915f6b884f5820bf8fd459f8200f8607e7462a78f7f6bda"
    sha256                               ventura:        "68b06d96d8772c6ad312c8f186a407d67d146e5ed92ec87ee346b8bbc7e97beb"
    sha256                               monterey:       "f7c5048fb7e0b52380983b946b983917f2f4d5314c4bff92e0369002dae5a49f"
    sha256                               big_sur:        "6953c079c4217758a6ebe68c6ff80468235264966a66cc6f1ea29fbf0741f217"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8824ce74362aaf244d83d1a9490e252cc698d9ca492811ffa76087384029026e"
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