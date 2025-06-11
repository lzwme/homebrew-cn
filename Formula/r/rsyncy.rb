class Rsyncy < Formula
  include Language::Python::Virtualenv

  desc "Statusprogress bar for rsync"
  homepage "https:github.comlaktakrsyncy"
  url "https:github.comlaktakrsyncyarchiverefstagsv0.2.1.tar.gz"
  sha256 "3832f71fbdfb3fbc3d135da91864abab44f16a9e9918d46389604a463bbf840f"
  license "MIT"
  head "https:github.comlaktakrsyncy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a67e111ca3ef8b9e2b4fd568b818e79fbb3ca6a8f1310d8707c2d79beb69e681"
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