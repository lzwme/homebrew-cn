class GitCredentialRbw < Formula
  desc "Credential helper for git to retrieve usernames and passwords from BitWarden"
  homepage "https://github.com/doy/rbw"
  url "https://ghfast.top/https://raw.githubusercontent.com/doy/rbw/1.14.1/bin/git-credential-rbw"
  sha256 "0207c0da6385d16ec307848bc8e01fc09c497e37700340596e5177a8ca558920"

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
    assert_equal "", `#{bin}/git-credential-rbw`
  end
end