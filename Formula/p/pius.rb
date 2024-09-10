class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https:github.comjaymzhpius"
  url "https:github.comjaymzhpiusarchiverefstagsv3.0.0.tar.gz"
  sha256 "3454ade5540687caf6d8b271dd18eb773a57ab4f5503fc71b4769cc3c5f2b572"
  license "GPL-2.0-only"
  revision 3
  head "https:github.comjaymzhpius.git", branch: "master"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, all: "955e8c9cf03a30cd3492596ed0e227eab2fa75c77120ccf763afbb437b940f8f"
  end

  depends_on "gnupg"
  depends_on "python@3.12"

  def install
    # Replace hardcoded gpg path (WONTFIX)
    inreplace "libpiusconstants.py", %r{usrbingpg2?}, "usrbinenv gpg"

    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      The path to gpg is hardcoded in pius as `usrbinenv gpg`.
      You can specify a different path by editing ~.pius:
        gpg-path=pathtogpg
    EOS
  end

  test do
    output = shell_output("#{bin}pius -T")
    assert_match "Welcome to PIUS, the PGP Individual UID Signer", output

    assert_match version.to_s, shell_output("#{bin}pius --version")
  end
end