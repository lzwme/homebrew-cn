require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.13.3.tgz"
  sha256 "bd3c75699f4897da4b7337fbe45eef1d0aed7253314603f9d709bedea4cee93c"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34fc5cfa5431129f9f75ead31880f078736861940546ab1effe30fb55eea0372"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34fc5cfa5431129f9f75ead31880f078736861940546ab1effe30fb55eea0372"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "34fc5cfa5431129f9f75ead31880f078736861940546ab1effe30fb55eea0372"
    sha256 cellar: :any_skip_relocation, sonoma:         "930ec39325da14ba9734bb9fad7206d8abb74ea6d274922f383d69150cdf3551"
    sha256 cellar: :any_skip_relocation, ventura:        "930ec39325da14ba9734bb9fad7206d8abb74ea6d274922f383d69150cdf3551"
    sha256 cellar: :any_skip_relocation, monterey:       "930ec39325da14ba9734bb9fad7206d8abb74ea6d274922f383d69150cdf3551"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31b2e3b34ac3876f1fef997cf50d079e292fdfac3f7e5c648a601ab83607223a"
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