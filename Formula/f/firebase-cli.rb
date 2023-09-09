require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.5.3.tgz"
  sha256 "1f2562d8b10982ae0a4f7ac427e77e3db017077aba601005ab8fbafadbb435f4"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a72bd3f88537fd3a27e1365faa8f4b824d2ddbee0198d9b6f28d6bf50de6ffb8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a72bd3f88537fd3a27e1365faa8f4b824d2ddbee0198d9b6f28d6bf50de6ffb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e04d1a29d1c77d9b71769c610237703b12b2a10fa28009660325138f61cf3d2a"
    sha256 cellar: :any_skip_relocation, ventura:        "e0948f1b0f6c3c9d6ec1e45f8eedb4d84d8aebe28ae1d2a7068eebf997efc560"
    sha256 cellar: :any_skip_relocation, monterey:       "e0948f1b0f6c3c9d6ec1e45f8eedb4d84d8aebe28ae1d2a7068eebf997efc560"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0948f1b0f6c3c9d6ec1e45f8eedb4d84d8aebe28ae1d2a7068eebf997efc560"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51d96c5a5fdcf853fbce2032bc4b5f9c0fadbb5a59a56b616c6066d2d65b9a54"
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