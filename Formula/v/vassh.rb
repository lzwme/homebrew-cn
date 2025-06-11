class Vassh < Formula
  desc "Vagrant Host-Guest SSH Command WrapperProxyForwarder"
  homepage "https:github.comxwpvassh"
  url "https:github.comxwpvassharchiverefstags0.2.tar.gz"
  sha256 "dd9b3a231c2b0c43975ba3cc22e0c45ba55fbbe11a3e4be1bceae86561b35340"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "941d5973bdb5b38f8e8b38331f84a5401c8689d09130b5cd770645e5881ee11d"
  end

  # upstream missing license report, https:github.comxwpvasshissues17
  disable! date: "2024-08-10", because: :no_license

  def install
    bin.install "vassh.sh", "vasshin", "vassh"
  end

  test do
    system bin"vassh", "-h"
  end
end