class GitCredentialKeepassxc < Formula
  desc "Helper that allows Git (and shell scripts) to use KeePassXC as credential store"
  homepage "https:github.comfrederick888git-credential-keepassxc"
  url "https:github.comFrederick888git-credential-keepassxcreleasesdownloadv0.14.1macos-latest-minimal.zip"
  sha256 "ba933bdfd0e996a60d078fd55de7378e101dafe6d799f1be9838e84efd04e1c8"

  def install
    bin.install Dir["*"]
  end

  test do
    system bin"git-credential-keepassxc", "--version"
    assert_equal "git-credential-keepassxc #{version} [release]\n", `#{bin}git-credential-keepassxc --version`
  end
end