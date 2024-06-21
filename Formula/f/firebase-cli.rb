require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.11.3.tgz"
  sha256 "156dde1ea8de61bca5053901a0e8b740122ff389f4a78a6cdba232c71ff260bf"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7102ed309ee9c937d259f0c751ba9728284943c1adb7fb2be714269e520ae430"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7102ed309ee9c937d259f0c751ba9728284943c1adb7fb2be714269e520ae430"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7102ed309ee9c937d259f0c751ba9728284943c1adb7fb2be714269e520ae430"
    sha256 cellar: :any_skip_relocation, sonoma:         "1fb32125747cd7ba42ba0fec22ac1a302b2f65b7b09f2af6e6f12a263cd176c1"
    sha256 cellar: :any_skip_relocation, ventura:        "1fb32125747cd7ba42ba0fec22ac1a302b2f65b7b09f2af6e6f12a263cd176c1"
    sha256 cellar: :any_skip_relocation, monterey:       "1fb32125747cd7ba42ba0fec22ac1a302b2f65b7b09f2af6e6f12a263cd176c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79811981337fdb14cfb3f5362b05df3d82ff0911c1fbbd49d1b970bba6af07b0"
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