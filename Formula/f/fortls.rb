class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https:fortls.fortran-lang.org"
  url "https:files.pythonhosted.orgpackagesf182b0f91372538de824bccb5e4fe8936e47f6771dbd700a74d35e19045050b5fortls-3.1.2.tar.gz"
  sha256 "93ea78598492ac699f7cefb624e89bf5012d44604d07fbe5ad4a31e32fc977bc"
  license "MIT"
  head "https:github.comfortran-langfortls.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "c066910b7c8381a0be2b56213aced45bf2b6b3ec4e62c3de19a027c602607727"
  end

  depends_on "python@3.12"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https:files.pythonhosted.orgpackages915951b032d53212a51f17ebbcc01bd4217faab6d6c09ed0d856a987a5f42bbcjson5-0.9.25.tar.gz"
    sha256 "548e41b9be043f9426776f05df8635a00fe06104ea51ed24b67f908856e151ae"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
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
    (testpath"test.f90").write <<~EOS
      program main
      end program main
    EOS
    system bin"fortls", "--debug_filepath", testpath"test.f90", "--debug_symbols", "--debug_full_result"
  end
end