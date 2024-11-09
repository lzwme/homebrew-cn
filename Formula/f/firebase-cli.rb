class FirebaseCli < Formula
  desc "Firebase command-line tools"
  homepage "https:firebase.google.comdocscli"
  url "https:registry.npmjs.orgfirebase-tools-firebase-tools-13.24.2.tgz"
  sha256 "c23f0cc37067568f87d8cbf730587fe23157d4aaad2c54a6939932d0af5ecf1b"
  license "MIT"
  head "https:github.comfirebasefirebase-tools.git", branch: "master"

  bottle do
    sha256                               arm64_sequoia: "cc0c7610c6f38b5b369d1489f58e4afda19905ad8bceeff15874b3a724a4eb4d"
    sha256                               arm64_sonoma:  "8b94e578b9bf9caf6a6e89ee672e62792a2011586585d0929bd9f09136ae79dc"
    sha256                               arm64_ventura: "588a2dd2d0572d8ded1ccc62052c3fdcd49436b6d2e028c386330405724e4abb"
    sha256                               sonoma:        "9407f399578322885c29b9a498eca501655735719a105138a4353512e2704ce8"
    sha256                               ventura:       "95718fd15a1627e2ca97911aec11e3ee07afc27d3fa6246b6d61e5de62daef52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2fcd2e692c3a998bbddc6de9ef31b546ecfc6f27fb818ced52a147f4cdff0bc"
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

    output = pipe_output("#{bin}firebase login:ci --interactive --no-localhost", "dummy-code")
    assert_match "Unable to authenticate", output
  end
end