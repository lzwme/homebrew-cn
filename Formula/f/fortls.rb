class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https:fortls.fortran-lang.org"
  url "https:files.pythonhosted.orgpackages33172e8e2aa4ccdf09569970b3f2587764692f93c82aa77421444509d3b58c68fortls-3.2.0.tar.gz"
  sha256 "4ec963d29977b57b7ce470986aba3ba26f40d08d96e358bb63f19c9a23f8a930"
  license "MIT"
  head "https:github.comfortran-langfortls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "24f719643578f366550f725f7baf1f395a826fa53c4c8d17c4e3abdde608c859"
  end

  depends_on "python@3.13"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https:files.pythonhosted.orgpackages853dbbe62f3d0c05a689c711cff57b2e3ac3d3e526380adb7c781989f075115cjson5-0.10.0.tar.gz"
    sha256 "e66941c8f0a02026943c52c2eb34ebeb2a6f819a0be05920a6f5243cd30fd559"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  def install
    virtualenv_install_with_resources

    # Disable automatic update check
    (bin"fortls").unlink
    (bin"fortls").write <<~EOS
      #!binsh
      exec #{libexec}binpython3 -m fortls --disable_autoupdate "$@"
    EOS
  end

  test do
    system bin"fortls", "--help"
    (testpath"test.f90").write <<~FORTRAN
      program main
      end program main
    FORTRAN
    system bin"fortls", "--debug_filepath", testpath"test.f90", "--debug_symbols", "--debug_full_result"
  end
end