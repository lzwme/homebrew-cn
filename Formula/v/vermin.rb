class Vermin < Formula
  include Language::Python::Virtualenv

  desc "Concurrently detect the minimum Python versions needed to run code"
  homepage "https://github.com/netromdk/vermin"
  url "https://files.pythonhosted.org/packages/c9/ec/ff9f006481d293c9703e1adb87b57c03fbb49f21d1534ed77ff5684e0790/vermin-1.9.1.tar.gz"
  sha256 "15abe48e5e8b228fb8694a28e7f31bb3cf6d38e7c40627c17708ce9fd8d42dc0"
  license "MIT"
  head "https://github.com/netromdk/vermin.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4e32a03d00da88798f31a5ddeebebc5dea1686cee014990f47fe4f1f87a4a92b"
  end

  depends_on "python@3.15"

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