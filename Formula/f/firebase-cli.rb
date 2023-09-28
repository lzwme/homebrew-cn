require "language/node"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https://firebase.google.com/docs/cli/"
  url "https://registry.npmjs.org/firebase-tools/-/firebase-tools-12.6.0.tgz"
  sha256 "fec55cc0b29936505f158f3fbbb297b2dedcd9cc74cf27076e26d61cd483258f"
  license "MIT"
  head "https://github.com/firebase/firebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c4fa395091f9a6cc624d89dc0a0fd1bb85a2d8c8629f65cab2f3101300b29749"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4fa395091f9a6cc624d89dc0a0fd1bb85a2d8c8629f65cab2f3101300b29749"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4fa395091f9a6cc624d89dc0a0fd1bb85a2d8c8629f65cab2f3101300b29749"
    sha256 cellar: :any_skip_relocation, sonoma:         "5d6685d621467be8c365efa53b4ef12b2df290833b5814cc512ce9d12c4d9b72"
    sha256 cellar: :any_skip_relocation, ventura:        "5d6685d621467be8c365efa53b4ef12b2df290833b5814cc512ce9d12c4d9b72"
    sha256 cellar: :any_skip_relocation, monterey:       "5d6685d621467be8c365efa53b4ef12b2df290833b5814cc512ce9d12c4d9b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "968fb349c09cfc7713c4f3b1e7f79efdd38c2dcd27973c29b5e7dad00f720559"
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