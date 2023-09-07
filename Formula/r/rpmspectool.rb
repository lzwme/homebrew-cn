class Rpmspectool < Formula
  include Language::Python::Virtualenv

  desc "Utility for handling RPM spec files"
  homepage "https://github.com/nphilipp/rpmspectool"
  url "https://files.pythonhosted.org/packages/0d/b9/723a043cca7407717238e7f5f9fd5df562aa4599204fdb1a76d652ebd281/rpmspectool-1.99.7.tar.gz"
  sha256 "359ab2c743bfe19cde5758e27d798e276aff63e1b9c8bb1bd307e89c07200ed6"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ae788048a8d4a77be470b7fc6fefc1d70c2cb4073e2a3634cbf962c84430d60c"
    sha256 cellar: :any_skip_relocation, ventura:       "964ebc4c8fad13b63affbbc5f800aba1551b4bcbbc7ad94556d87d791e156b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3b27e1de9b1da031214a7cfd84e39491faca0f84fa616f1f358b8602c7961bca"
  end

  depends_on "python-pycurl"
  depends_on "python@3.11"
  depends_on "rpm"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/54/c9/41c4dfde7623e053cbc37ac8bc7ca03b28093748340871d4e7f1630780c4/argcomplete-3.1.1.tar.gz"
    sha256 "6c4c563f14f01440aaffa3eae13441c5db2357b5eec639abe7c0b15334627dff"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/".rpmmacros").write <<~EOS
      %_topdir  %(echo $HOME)/rpmbuild
      %_tmppath %_topdir/tmp
    EOS

    (testpath/"hello.spec").write <<~EOS
      Name:           hello
      Version:        2.12.1
      Release:        1
      Summary:        Prints a familiar, friendly greeting
      License:        GPL-3.0-or-later AND GFDL-1.3-or-later
      URL:            https://www.gnu.org/software/hello/
      Source0:        https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz

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
      rm -f $RPM_BUILD_ROOT/%_infodir/dir
      %find_lang hello

      %files -f hello.lang
      %license COPYING
      %_mandir/man1/hello.1*
      %_bindir/hello
      %_infodir/hello.info*
    EOS
    system bin/"rpmspectool", "get", testpath/"hello.spec"
    assert_predicate testpath/"hello-2.12.1.tar.gz", :exist?
  end
end