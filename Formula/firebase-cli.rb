require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.27.0.tgz"
  sha256 "faadbab631dbf2338ed99016d1b0a4caf7fd5ca67f329a32265432c73a95c0ef"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "79a98df51b984064bb77c4635e1d0556b7f218d3ff86baf912caf973c8461d4f"
    sha256                               arm64_monterey: "9135ee43173f34650c152b93503d7ff29a800ad0b48d5a9732f1210c10e7c729"
    sha256                               arm64_big_sur:  "ea3ddfb5ccf653cd75de997927b57b5084701be6816b5553024302ace67aeeb2"
    sha256 cellar: :any_skip_relocation, ventura:        "dffe9a311cf56239445754fe6b25971596848124e0580d5174b3dbcfcff0a937"
    sha256 cellar: :any_skip_relocation, monterey:       "dffe9a311cf56239445754fe6b25971596848124e0580d5174b3dbcfcff0a937"
    sha256 cellar: :any_skip_relocation, big_sur:        "dffe9a311cf56239445754fe6b25971596848124e0580d5174b3dbcfcff0a937"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a7e8838992981f5f9450343b8ed75998aa503e2b1d20d209341d075607baf0e"
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