require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-13.0.0.tgz"
  sha256 "185390c00a143b1f216a414a2aa3a7658b74ef9f08ded0cf1d3d200879cf2870"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32d21c06b2b5be1c7391e2d7cfe22b3eb2e38270eb3cea6f722c053b0527976a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32d21c06b2b5be1c7391e2d7cfe22b3eb2e38270eb3cea6f722c053b0527976a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32d21c06b2b5be1c7391e2d7cfe22b3eb2e38270eb3cea6f722c053b0527976a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d087127cdc4123821557f64692175901660e58d66725af17ada926e8e8a344ca"
    sha256 cellar: :any_skip_relocation, ventura:        "d087127cdc4123821557f64692175901660e58d66725af17ada926e8e8a344ca"
    sha256 cellar: :any_skip_relocation, monterey:       "d087127cdc4123821557f64692175901660e58d66725af17ada926e8e8a344ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef0e4b0e46f744edd1aa3c166bd51d171bf97365ddc3a56ca1eb9cf905e14532"
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