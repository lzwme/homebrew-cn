class GitCredentialRbw < Formula
  desc "Credential helper for git to retrieve usernames and passwords from BitWarden"
  homepage "https://github.com/doy/rbw"
  url "https://ghproxy.com/https://raw.githubusercontent.com/doy/rbw/1.8.3/bin/git-credential-rbw"
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
end