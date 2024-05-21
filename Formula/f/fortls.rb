class Fortls < Formula
  include Language::Python::Virtualenv

  desc "Fortran language server"
  homepage "https:fortls.fortran-lang.org"
  url "https:files.pythonhosted.orgpackages7a3fdb215a89836cf9c9e7d2039f9ded31511fdaeceb63bb8bc8d0e01714b1a0fortls-3.1.0.tar.gz"
  sha256 "e38f9f6af548f78151d54bdbb9884166f8d717f8e147ab1e2dbf06b985df2c6d"
  license "MIT"
  head "https:github.comfortran-langfortls.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "00bcd81cccbe00902df21ec67f947e7fa159c3f0532e57090dee8ad7125a8f9e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "816a8bb69dfb03574e6ad9322e2ab5d022f9f402d40a25e718e498b042ff4132"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "863801d634f7f56948ec657c0f0cca3748cd95698632e7aa94a76b72af9daddb"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb1f012c33bb89eeaea4597215cb6c4683554e67d100b2e080720d4174fd237a"
    sha256 cellar: :any_skip_relocation, ventura:        "d842a5fa5ba725875960bbaf6d003a34daa19c05fbcdde26f36c4d60b2bc33b8"
    sha256 cellar: :any_skip_relocation, monterey:       "e3862d45d0ef7f7122f128aa2374e935f31a156a8404c86df29b5b19c0002ae2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b8b492f31f2329c07f04b24f73319e0892b2e0fcd6e84eadc4142085c271742"
  end

  depends_on "python@3.12"

  conflicts_with "fortran-language-server", because: "both install `fortls` binaries"

  resource "json5" do
    url "https:files.pythonhosted.orgpackages915951b032d53212a51f17ebbcc01bd4217faab6d6c09ed0d856a987a5f42bbcjson5-0.9.25.tar.gz"
    sha256 "548e41b9be043f9426776f05df8635a00fe06104ea51ed24b67f908856e151ae"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
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