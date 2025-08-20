class Asciinema < Formula
  include Language::Python::Virtualenv

  desc "Record and share terminal sessions"
  homepage "https://asciinema.org"
  url "https://files.pythonhosted.org/packages/f1/19/45b405438e90ad5b9618f3df62e9b3edaa2b115b530e60bd4b363465c704/asciinema-2.4.0.tar.gz"
  sha256 "828e04c36ba622a7b8f8f912c8f0c1329538b6c7ed1c0d1b131bbbfe3a221707"
  license "GPL-3.0-only"
  revision 1
  head "https://github.com/asciinema/asciinema.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "25d158a0f9a9dcfd554504babc73196b0a0b8cdeea7390c425b7b209bbdb7015"
  end

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    output = shell_output("#{bin}/asciinema auth 2>&1")
    assert_match "Open the following URL in a web browser to link your install ID", output
  end
end