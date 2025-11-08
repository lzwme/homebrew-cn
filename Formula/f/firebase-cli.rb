class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-14.24.1.tgz"
  sha256 "2c797ec7a586842636d6f29073f02f8216d68e353951f734b45fe1d4a4da1e9d"
  license "MIT"

  bottle do
    sha256                               arm64_tahoe:   "1a8a46f9d8ba7210fa50cc479a4f19ec1dc382793baa1d3816cf20c01564876b"
    sha256                               arm64_sequoia: "3662920a7a4c9534270557ddf014c5a43dd4a0a7be4f953ff8c9e62b9fd10e5e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ddc40da5d3143cdded9531a7e0521643120c28ce42f6d2c95e5e71f0c0b23c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ddc40da5d3143cdded9531a7e0521643120c28ce42f6d2c95e5e71f0c0b23c9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d7576bc1634be7dd3404c790eee631f9e13240973f57f4654eb77988000ac0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d00efbfb97986bd1366fea961cc8d8f27d7489526ac6b786fac803e86a2570f8"
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