class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automatically building modern Fortran projects"
  homepage "https://github.com/szaghi/FoBiS"
  url "https://files.pythonhosted.org/packages/e2/c6/d907008cb2994b1fa20324028b5fedafb440615024631a6803231f7768df/fobis_py-3.2.1.tar.gz"
  sha256 "123bb026f8cba20ed81db5355cc39be1d64408d646e5aeaf4706be4b021a8669"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "14d6e1565ee1d267168023e174abdd11b04c1677ada3b69b1d4606b22b434d5a"
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python@3.14"

  resource "configparser" do
    url "https://files.pythonhosted.org/packages/8b/ac/ea19242153b5e8be412a726a70e82c7b5c1537c83f61b20995b2eda3dcd7/configparser-7.2.0.tar.gz"
    sha256 "b629cc8ae916e3afbd36d1b3d093f34193d851e11998920fdcfc4552218b7b70"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-mod.f90").write <<~FORTRAN
      module fobis_test_m
        implicit none
        character(*), parameter :: message = "Hello FoBiS"
      end module
    FORTRAN

    (testpath/"test-prog.f90").write <<~FORTRAN
      program fobis_test
        use iso_fortran_env, only: stdout => output_unit
        use fobis_test_m, only: message
        implicit none
        write(stdout,'(A)') message
      end program
    FORTRAN

    system bin/"FoBiS.py", "build", "-compiler", "gnu"
    assert_match "Hello FoBiS", shell_output(testpath/"test-prog")
  end
end