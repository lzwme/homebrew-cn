class Rsyncy < Formula
  include Language::Python::Virtualenv

  desc "Statusprogress bar for rsync"
  homepage "https:github.comlaktakrsyncy"
  url "https:github.comlaktakrsyncyarchiverefstagsv0.2.0-1.tar.gz"
  sha256 "b2f1c0e49f63266b3a81b0c7925592a405770a3e1296040a106b503a85024b00"
  license "MIT"
  head "https:github.comlaktakrsyncy.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c9f3bf3e3e2b3b67497decbe21a1accbc9e18b1a020fcd7c696bc3eb768396b1"
  end

  depends_on "python@3.13"
  depends_on "rsync"

  uses_from_macos "zlib"

  def install
    virtualenv_install_with_resources
  end

  test do
    # rsyncy is a wrapper, rsyncy --version will invoke it and show rsync output
    assert_match(.*rsync.+version.*, shell_output("#{bin}rsyncy --version"))

    # test copy operation
    mkdir testpath"a" do
      mkdir "foo"
      (testpath"afooone.txt").write <<~EOS
        testing
        testing
        testing
      EOS
      system bin"rsyncy", "-r", testpath"afoo", testpath"abar"
      assert_path_exists testpath"abarone.txt"
    end
  end
end