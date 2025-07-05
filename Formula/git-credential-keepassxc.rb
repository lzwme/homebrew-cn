class GitCredentialKeepassxc < Formula
  desc "Helper that allows Git (and shell scripts) to use KeePassXC as credential store"
  homepage "https://github.com/frederick888/git-credential-keepassxc"
  url "https://ghfast.top/https://github.com/Frederick888/git-credential-keepassxc/releases/download/v0.14.1/macos-latest-minimal.zip"
  sha256 "ba933bdfd0e996a60d078fd55de7378e101dafe6d799f1be9838e84efd04e1c8"

  def install
    bin.install Dir["*"]
  end

  test do
    system bin/"git-credential-keepassxc", "--version"
    assert_equal "git-credential-keepassxc #{version} [release]\n", `#{bin}/git-credential-keepassxc --version`
  end
end