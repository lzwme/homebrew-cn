class Rpmspectool < Formula
  include Language::Python::Virtualenv

  desc "Utility for handling RPM spec files"
  homepage "https:github.comnphilipprpmspectool"
  url "https:files.pythonhosted.orgpackages7dcc53ef9a699df75f3f29f672d0bdf7aae162829e2c98f7b7b5f063fd5d3a46rpmspectool-1.99.10.tar.gz"
  sha256 "b79d59388ecba5f8b957c722a43a429b5a728435f5ed0992011e9482850e3583"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "998212959687c76fc3f7ce05de22cbf55a7db9e9c94d77fe0c5de4b9075c9360"
  end

  depends_on "curl"
  depends_on :linux
  depends_on "openssl@3"
  depends_on "python@3.13"
  depends_on "rpm"

  resource "argcomplete" do
    url "https:files.pythonhosted.orgpackages7f03581b1c29d88fffaa08abbced2e628c34dd92d32f1adaed7e42fc416938b0argcomplete-3.5.2.tar.gz"
    sha256 "23146ed7ac4403b70bd6026402468942ceba34a6732255b9edf5b7354f68a6bb"
  end

  resource "pycurl" do
    url "https:files.pythonhosted.orgpackagesc95ae68b8abbc1102113b7839e708ba04ef4c4b8b8a6da392832bb166d09ea72pycurl-7.45.3.tar.gz"
    sha256 "8c2471af9079ad798e1645ec0b0d3d4223db687379d17dd36a70637449f81d6b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath".rpmmacros").write <<~EOS
      %_topdir  %(echo $HOME)rpmbuild
      %_tmppath %_topdirtmp
    EOS

    (testpath"hello.spec").write <<~EOS
      Name:           hello
      Version:        2.12.1
      Release:        1
      Summary:        Prints a familiar, friendly greeting
      License:        GPL-3.0-or-later AND GFDL-1.3-or-later
      URL:            https:www.gnu.orgsoftwarehello
      Source0:        https:ftp.gnu.orggnuhellohello-2.12.1.tar.gz

      %description
      The GNU Hello program produces a familiar, friendly greeting.
      Yes, this is another implementation of the classic program that
      prints “Hello, world!” when you run it.

      %prep
      %setup -q

      %build
      %configure
      %make_build

      %install
      %make_install
      rm -f $RPM_BUILD_ROOT%_infodirdir
      %find_lang hello

      %files -f hello.lang
      %license COPYING
      %_mandirman1hello.1*
      %_bindirhello
      %_infodirhello.info*
    EOS
    system bin"rpmspectool", "get", testpath"hello.spec"
    assert_predicate testpath"hello-2.12.1.tar.gz", :exist?
  end
end