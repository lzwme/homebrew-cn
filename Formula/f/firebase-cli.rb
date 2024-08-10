class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.15.1.tgz"
  sha256 "3195d0cec1c2923f4653f6096b6a4ab782c5a715a8b875296d9451b4c4a51818"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9bdc5820e0f76f241b7ab9a8723d82ac88db23e962059a1e12098faaa41ddd8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bdc5820e0f76f241b7ab9a8723d82ac88db23e962059a1e12098faaa41ddd8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bdc5820e0f76f241b7ab9a8723d82ac88db23e962059a1e12098faaa41ddd8f"
    sha256 cellar: :any_skip_relocation, sonoma:         "757beab829731c82c437293cdc5495b12ccfb9d0eddebdce0a88e532f4f2dca1"
    sha256 cellar: :any_skip_relocation, ventura:        "757beab829731c82c437293cdc5495b12ccfb9d0eddebdce0a88e532f4f2dca1"
    sha256 cellar: :any_skip_relocation, monterey:       "757beab829731c82c437293cdc5495b12ccfb9d0eddebdce0a88e532f4f2dca1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1f42b196ff1f5c157a360c530305a983c9a7ee03ad91431825e5641139f49a1"
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