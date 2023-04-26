require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-11.29.0.tgz"
  sha256 "616d7bda0ac9a2daad6e101e8ab00466168f2fcbe2dac381ed2f1c8aed15eda5"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "9678c308195eaebdcd64da3b7e8d41093f751cc7b31c6745f37fbdabd7ea2654"
    sha256                               arm64_monterey: "d7cc08353cce21f2e134e821ca83a12423e6c79bafce1bd2563b288859b2902c"
    sha256                               arm64_big_sur:  "42133490cc2075a5758a95bbc442ec07c2a6e20026959c35ded3f322eaf6e9b8"
    sha256                               ventura:        "51eb73ee166bfc4df5ebd6247bba55cc1d0ade986226ebd09d8a29c931babd70"
    sha256                               monterey:       "22c3b3b5e738ecd9ee5a5ae2ad1cf2592a7c93c8b2b9859f64d99d6ebc6d777c"
    sha256                               big_sur:        "15d7c379ea61b10e391808e24b974901ee5ea1975f4d26e85122eebcbe2f4b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ca1b18473987c67d242d122915267a096ba0e1b23d89a6ffd2b49539a50727f"
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