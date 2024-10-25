class GitCredentialLastpass < Formula
  desc "Credential helper for git to retrieve usernames and passwords from lastpass"
  homepage "https:github.comnicerloopgit-credential-lastpass"
  url "https:github.comnicerloopgit-credential-lastpassarchiverefstagsv1.8.0.tar.gz"
  sha256 "366f880ffe4f0c45a4c7c1892e380ec37cc0b766331f5f0568afd90d8ba3b87c"

  depends_on "lastpass-cli"
  depends_on "pinentry-mac"

  def install
    bin.install "git-credential-lastpass"
  end

  def caveats
    <<~EOS
      To set up this git credential helper:
        git config --global credential.helper "lastpass"
    EOS
  end

  test do
    system bin"git-credential-lastpass", "--version"
    assert_equal "", `#{bin}git-credential-lastpass --version`
  end
end