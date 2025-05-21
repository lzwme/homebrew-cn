class Fobis < Formula
  include Language::Python::Virtualenv

  desc "KISS build tool for automatically building modern Fortran projects"
  homepage "https:github.comszaghiFoBiS"
  url "https:files.pythonhosted.orgpackages0cb06c713be09d7d0cb3af98e3f5ec3d29aa74d85de571936242ba2cb0b51736FoBiS.py-3.1.0.tar.gz"
  sha256 "1c1df040c42596de49e402b00823e6feec1c06b2d6bc7ffcb1a6db605e75e9e1"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1b1f66d81ce0cdbbe8e74af5922384040aec477f8e9fdbf76bfae4672bd17f0e"
  end

  depends_on "gcc" # for gfortran
  depends_on "graphviz"
  depends_on "python@3.13"

  resource "configparser" do
    url "https:files.pythonhosted.orgpackages8bacea19242153b5e8be412a726a70e82c7b5c1537c83f61b20995b2eda3dcd7configparser-7.2.0.tar.gz"
    sha256 "b629cc8ae916e3afbd36d1b3d093f34193d851e11998920fdcfc4552218b7b70"
  end

  resource "future" do
    url "https:files.pythonhosted.orgpackagesa7b24140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3bafuture-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"test-mod.f90").write <<~FORTRAN
      module fobis_test_m
        implicit none
        character(*), parameter :: message = "Hello FoBiS"
      end module
    FORTRAN

    (testpath"test-prog.f90").write <<~FORTRAN
      program fobis_test
        use iso_fortran_env, only: stdout => output_unit
        use fobis_test_m, only: message
        implicit none
        write(stdout,'(A)') message
      end program
    FORTRAN

    system bin"FoBiS.py", "build", "-compiler", "gnu"
    assert_match "Hello FoBiS", shell_output(testpath"test-prog")
  end
end