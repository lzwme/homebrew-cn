class GitCredentialKeepassxc < Formula
  desc "Helper that allows Git (and shell scripts) to use KeePassXC as credential store"
  homepage "https://github.com/frederick888/git-credential-keepassxc"
  url "https://ghproxy.com/https://github.com/Frederick888/git-credential-keepassxc/releases/download/v0.13.0/macos-latest-minimal.zip"
  sha256 "1be3e43ad4de2ac29e1b71c626970cb9890cddc9ee46037f7411ad07761c3280"

  def install
    bin.install Dir["*"]
  end
end