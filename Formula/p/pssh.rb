class Pssh < Formula
  include Language::Python::Virtualenv

  desc "Parallel versions of OpenSSH and related tools"
  homepage "https://github.com/lilydjwg/pssh"
  url "https://ghfast.top/https://github.com/lilydjwg/pssh/archive/refs/tags/v2.3.5.tar.gz"
  sha256 "97277f9d08b512c6a1b6dc5eac9677f34038096bae24484452d326137ba0d080"
  license "BSD-3-Clause"
  head "https://github.com/lilydjwg/pssh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71f66f7ce2b43dede8c6719028a4772db8d453d568bc88cd57c93987ecde5743"
  end

  depends_on "python@3.14"

  conflicts_with "putty", because: "both install `pscp` binaries"

  def install
    virtualenv_install_with_resources
    man1.install buildpath.glob("man/man1/*.1")
  end

  test do
    system bin/"pssh", "--version"
  end
end