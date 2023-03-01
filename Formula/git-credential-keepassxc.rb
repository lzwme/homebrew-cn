class GitCredentialKeepassxc < Formula
  desc "Helper that allows Git (and shell scripts) to use KeePassXC as credential store"
  homepage "https://github.com/frederick888/git-credential-keepassxc"
  url "https://ghproxy.com/https://github.com/Frederick888/git-credential-keepassxc/releases/download/v0.12.0/macos-latest-minimal.zip"
  sha256 "951ec554b4c7e43d55fb61905a24980fe69c690b3013473af24d6e27c2b99941"

  def install
    bin.install Dir["*"]
  end
end