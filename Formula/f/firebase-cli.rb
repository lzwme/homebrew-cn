class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.15.0.tgz"
  sha256 "0a4c9ffcbc47231f411880678eb302753d9ab2faa052ef0c03a41c743d3eab06"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "58746d87a088a6dd8ee4ba036dc587af185e5e4410ef8f79a93375379bd3f021"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58746d87a088a6dd8ee4ba036dc587af185e5e4410ef8f79a93375379bd3f021"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58746d87a088a6dd8ee4ba036dc587af185e5e4410ef8f79a93375379bd3f021"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5d13d47a3347e61799ff054f4120239f989af54e990fcb972047f694987a4c4"
    sha256 cellar: :any_skip_relocation, ventura:        "f5d13d47a3347e61799ff054f4120239f989af54e990fcb972047f694987a4c4"
    sha256 cellar: :any_skip_relocation, monterey:       "f914198615657f879fadff63dda25f81c82bba6e3846931f8be6453750e59d9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b2492ddd29f71ab33a451ce21a0290223c761141a4bf434bfea08131b86281c"
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *std_npm_args
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