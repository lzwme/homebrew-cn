class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.20.0.tgz"
  sha256 "07cc63517dbd65cbccbe78073a592cb276d3b981ffd7d953279e80670000684c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4bcba37d86e1ae404dbfb62023ad257b9c35908d2e11e40e29f101ddbb1260b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4bcba37d86e1ae404dbfb62023ad257b9c35908d2e11e40e29f101ddbb1260b9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4bcba37d86e1ae404dbfb62023ad257b9c35908d2e11e40e29f101ddbb1260b9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7894846e5313192681efdaafb7c5f790a261e426c56789113a49369fe8c17cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f1872a94164d389064bb431c09e4bd23d3261fdb11e649d4663f352f59fa6a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a54f46fa0d3701396b4e9db226391aed9d1b413d87f2b39db14f97bcb04db6de"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/firebase --version")

    assert_match "Failed to authenticate", shell_output("#{bin}/firebase projects:list", 1)
  end
end