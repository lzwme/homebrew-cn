require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.4.4.tgz"
  sha256 "c973b93232372a7d560e467bdb7efcb57cadc4fe2c6684adacce8b87084db89d"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "c6343acd80d05ce74440106527c0fc666a9e2303969168448b984cf9cfe4ab99"
    sha256                               arm64_monterey: "c2f89d10e8213b8ded21edc7f525a2d2a2a3421bcd9c79d2a7a747001d0d2c11"
    sha256                               arm64_big_sur:  "a011acdf6c89207a2b842b70e67fa4cb1c86932a17925fb394a617933140404e"
    sha256 cellar: :any_skip_relocation, ventura:        "0e2faf61d9d4ae5ac8809696012a965cfe4cb86e4fb0497505bf86982ef07fb8"
    sha256 cellar: :any_skip_relocation, monterey:       "0e2faf61d9d4ae5ac8809696012a965cfe4cb86e4fb0497505bf86982ef07fb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e2faf61d9d4ae5ac8809696012a965cfe4cb86e4fb0497505bf86982ef07fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39e7035df281cca03fd61f2021b02553cf0bda5ba148d4ee7cc0d1aac214bce6"
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