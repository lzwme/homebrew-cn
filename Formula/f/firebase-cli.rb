require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.10.1.tgz"
  sha256 "f77ba3553eb9b6886371858772013799f279c61f229626e2dc5cf9f0aabacd92"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2c4134e5296b6f27c3ecf7e08f6474ab1a81fa438b0292156d23d1ffd5904a78"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3fde0c0a0ccab5bf1fd7d6b0891f5435bdc7a2d7b67e56339411699c915b8d2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac853a0cb3c8e6ea9bf5615d31b66c536617a55388b0a3a5a8cca963f38e97c5"
    sha256                               sonoma:         "360d377fb4541030fb5eb4198898f559366d26b1fb80edc1f932684078bc3814"
    sha256                               ventura:        "08e2f12e339274c00a91e9f400803b5b82ca677ba9a8ae14a1cd4b04c710b7a2"
    sha256                               monterey:       "6c89c1177d91d31ef7879a8bfecf78c17e869e2016b0fa962b9cf5c6e91e28c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d91fad02ec9d54143c3e25a11a68951a88ffc1cdaf45c6dcd80f81231db053af"
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