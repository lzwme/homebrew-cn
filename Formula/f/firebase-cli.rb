require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.0.3.tgz"
  sha256 "e6cd72ecf58557fce04ee58c3d05cf88ac5d1ffe910b439fc4cb688977e68ed8"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e2998c409f796269c4bfc42b4235d44775154ee6ad8689495d616699f030a18a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2998c409f796269c4bfc42b4235d44775154ee6ad8689495d616699f030a18a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2998c409f796269c4bfc42b4235d44775154ee6ad8689495d616699f030a18a"
    sha256 cellar: :any_skip_relocation, sonoma:         "372571d0d0ee860d2fa73039335a2b426648ab71265380ec6833e47787dd2cc1"
    sha256 cellar: :any_skip_relocation, ventura:        "372571d0d0ee860d2fa73039335a2b426648ab71265380ec6833e47787dd2cc1"
    sha256 cellar: :any_skip_relocation, monterey:       "372571d0d0ee860d2fa73039335a2b426648ab71265380ec6833e47787dd2cc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78968a823c5c50102704f1a63eceba45922300aa32fe171c0741b7e0c6f58a4b"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}bin*"]
  end

  test do
    (testpath"test.exp").write <<~EOS
      spawn #{bin}firebase login:ci --no-localhost
      expect "Paste"
    EOS
    assert_match "authorization code", shell_output("expect -f test.exp")
  end
end