class Pius < Formula
  include Language::Python::Virtualenv

  desc "PGP individual UID signer"
  homepage "https://github.com/jaymzh/pius"
  url "https://ghfast.top/https://github.com/jaymzh/pius/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "3454ade5540687caf6d8b271dd18eb773a57ab4f5503fc71b4769cc3c5f2b572"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/jaymzh/pius.git", branch: "master"

  bottle do
    rebuild 6
    sha256 cellar: :any_skip_relocation, all: "3f3e1fff9df0dffb6684ab3c51f31f7d45fa3ae4be39e97f6695d5f4164494a2"
  end

  depends_on "gnupg"
  depends_on "python@3.13"

  def install
    # Replace hardcoded gpg path (WONTFIX)
    inreplace "libpius/constants.py", %r{/usr/bin/gpg2?}, "/usr/bin/env gpg"

    virtualenv_install_with_resources
  end

  def caveats
    <<~TEXT
      The path to gpg is hardcoded in pius as `/usr/bin/env gpg`.
      You can specify a different path by editing ~/.pius:
        gpg-path=/path/to/gpg
    TEXT
  end

  test do
    output = shell_output("#{bin}/pius -T")
    assert_match "Welcome to PIUS, the PGP Individual UID Signer", output

    assert_match version.to_s, shell_output("#{bin}/pius --version")
  end
end