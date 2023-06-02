require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.3.0.tgz"
  sha256 "b39dc888f69725f4387ce5ea27cbc4c4692a934c48f8d9e9e12af86385d24b3b"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6a631c69e3f864927f19195160841ade9eec3b19c4ed30ac5f62d79e927d5f1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6a631c69e3f864927f19195160841ade9eec3b19c4ed30ac5f62d79e927d5f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a6a631c69e3f864927f19195160841ade9eec3b19c4ed30ac5f62d79e927d5f1"
    sha256 cellar: :any_skip_relocation, ventura:        "4e29dc35b0a7cb2cdd3779ef80e04b1b369a97242535b35af7eed05ff3e57179"
    sha256 cellar: :any_skip_relocation, monterey:       "4e29dc35b0a7cb2cdd3779ef80e04b1b369a97242535b35af7eed05ff3e57179"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e29dc35b0a7cb2cdd3779ef80e04b1b369a97242535b35af7eed05ff3e57179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9010ef155dc32b8419d6eca2aef64a2424ceb272c5c3e3bc734be4d77b2b78a"
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