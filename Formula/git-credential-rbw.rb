class GitCredentialRbw < Formula
  desc "Credential helper for git to retrieve usernames and passwords from BitWarden"
  homepage "https:github.comdoyrbw"
  url "https:raw.githubusercontent.comdoyrbw1.13.1bingit-credential-rbw"
  sha256 "f9a2c58060e212fc731087b1ee0b30fd81925caa7361d9233f499e6154c1df8e"

  depends_on "rbw"

  def install
    bin.install "git-credential-rbw"
  end

  def caveats
    <<~EOS
      To set up this git credential helper:
        git config --global credential.helper rbw
    EOS
  end

  test do
    assert_equal "", `#{bin}git-credential-rbw`
  end
end