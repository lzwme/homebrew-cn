require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.25.3.tgz"
  sha256 "52c6b9cf60eb9ad9c109b4bd279244658bd5802a17502fb52fdbd1781bca7a45"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "5b34bff54fdd8be539202d3fbdcd821950690a352c7c01ce0a9946591197ef9a"
    sha256                               arm64_monterey: "52f47a81849d0b2d5e4dd60358b505ac3c944b9121b9a97c2716095030fa9b45"
    sha256                               arm64_big_sur:  "c247b66102032244c4933d59c2e235b2abcb21274af494127ae2586b8a5cd03f"
    sha256 cellar: :any_skip_relocation, ventura:        "2cd5d47239a9f37704a9a9e8ba3098becfa64151fa2e5ffe7071fc58fbc7932a"
    sha256 cellar: :any_skip_relocation, monterey:       "2cd5d47239a9f37704a9a9e8ba3098becfa64151fa2e5ffe7071fc58fbc7932a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cd5d47239a9f37704a9a9e8ba3098becfa64151fa2e5ffe7071fc58fbc7932a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae419a3b5e4d20f3470f5b2e471954158f686e7a02e5973f8bc4fb260a4fe08"
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