class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://files.pythonhosted.org/packages/93/10/55e6b248ef9d757d521210d04418ac73417d850cbaa6b0366a7f6291d4dc/vermin-1.7.0.tar.gz"
  sha256 "e9e3c2c901dc2ceec746d9b9e807d6639ec4233a749ad62f51bc0334fbb38707"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f98f5ae78d3a75725e6def0a1dc52381cfc23983f41236468da51c40bd5a641a"
  end

  depends_on "python@3.14"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal <<~EOS, shell_output("#{bin}/vermin --no-parse-comments #{bin}/vermin")
      Minimum required versions: ~2, ~3
      Note: Not enough evidence to conclude it won't work with Python 2 or 3.
    EOS

    assert_match version.to_s, shell_output("#{bin}/vermin --version")
  end
end