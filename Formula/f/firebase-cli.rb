class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-14.3.0.tgz"
  sha256 "2238f5d821af3e66d6b89e6e0b09596c7aa034ef12067dc320645d5d5fc467ec"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "b8e10a5cef55a5b20007fbdc422d550875019963d3d6569287663cc3a49e43a8"
    sha256                               arm64_sonoma:  "aa21ef230938e420270e4b449a17f71966b8615c74c4d5a62313578e468839e6"
    sha256                               arm64_ventura: "f5c7d104c845c9440c5acfcc006657fb77058d967c365f1c62701cc76a2ee803"
    sha256                               sonoma:        "c6d9f2791f44a17e2234bce88bd5dd01614427d6785952d971d77cda08e17966"
    sha256                               ventura:       "1c2227460600cf490578210b00e03b71d3f25f96805943edbf675a1233d19ed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "79b2cc3ba9cc58859597f43c6c0106d50bde5ecbbf716e522f3cd6c118d392aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c2875e4edd3d8271e85d0c5c6920886b8e0b3e7365a9e761b0839113baa17066"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin*")
  end

  test do
    # Skip `firebase init` on self-hosted Linux as it has different behavior with nil exit status
    if !OS.linux? || ENV["GITHUB_ACTIONS_HOMEBREW_SELF_HOSTED"].blank?
      assert_match "Failed to authenticate", shell_output("#{bin}firebase init", 1)
    end

    output = shell_output("#{bin}firebase use dev 2>&1", 1)
    assert_match "Failed to authenticate, have you run \e[1mfirebase login\e[22m?", output
  end
end