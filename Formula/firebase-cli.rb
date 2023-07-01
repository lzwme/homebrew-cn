require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.4.2.tgz"
  sha256 "d5c4f146f723a6025c7a61ea0954301958504e0321c190bb38dd9164357e869b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_ventura:  "0246eb577dad5e6117a713370fe0a96af731770fc4148504bfdfef117c46e397"
    sha256                               arm64_monterey: "4de6cd92015a70183f1ff7094226e727dafe5dc872f7a40a7fbf8864ef405115"
    sha256                               arm64_big_sur:  "0bb12c5f69753ddcc5ef2f402eeed57406c02458b69d8f834735eef68dec150f"
    sha256 cellar: :any_skip_relocation, ventura:        "f07aeb63df3ac4e3e133e5657ba46f03589e9f3d14645be31dab8dcd9da33463"
    sha256 cellar: :any_skip_relocation, monterey:       "f07aeb63df3ac4e3e133e5657ba46f03589e9f3d14645be31dab8dcd9da33463"
    sha256 cellar: :any_skip_relocation, big_sur:        "f07aeb63df3ac4e3e133e5657ba46f03589e9f3d14645be31dab8dcd9da33463"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e8299fe8b139de2dc4644344e18c39bf9c0c28ccc9448332ce7c65cb94c84e2"
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