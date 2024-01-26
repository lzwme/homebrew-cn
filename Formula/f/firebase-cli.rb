require "languagenode"

class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.1.0.tgz"
  sha256 "ae92f873a24aba34c6d63d2c1985c758284874993e5dbc53d7d6ba38d0911892"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a96eb6851dc2f5ae471c4d96a3439784eaf498e74a34f95ddf12ff2f4c78bb55"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a96eb6851dc2f5ae471c4d96a3439784eaf498e74a34f95ddf12ff2f4c78bb55"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a96eb6851dc2f5ae471c4d96a3439784eaf498e74a34f95ddf12ff2f4c78bb55"
    sha256 cellar: :any_skip_relocation, sonoma:         "02785e6315082559c9beb736d89600458c09116897143c1ad0b1a0360b77eb7f"
    sha256 cellar: :any_skip_relocation, ventura:        "02785e6315082559c9beb736d89600458c09116897143c1ad0b1a0360b77eb7f"
    sha256 cellar: :any_skip_relocation, monterey:       "02785e6315082559c9beb736d89600458c09116897143c1ad0b1a0360b77eb7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34b96c83f0534c24d1335fab223573b8f6b4124b50436a182e208401e408cfd9"
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