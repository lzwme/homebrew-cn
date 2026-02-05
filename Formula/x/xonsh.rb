class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  # xon.sh homepage bug report, https://github.com/xonsh/xonsh/issues/5984
  homepage "https://github.com/xonsh/xonsh"
  url "https://files.pythonhosted.org/packages/87/4b/c18878e91e54ae92df558c0af2928d32a0c0259f2f3032fa80b0fb6be59b/xonsh-0.22.3.tar.gz"
  sha256 "67468d9689cdfc88c90b3530c696b70f540959216968c016bea3645343134069"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e38f8e971a1571f20107c4dc7cce13df84d5599c8ef8c6cf6fffc97aba0cd28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3d0de8fe2ef05a485c82e6a6b02dc2d679e2ff0d867a2419e82c8cf0466559d4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "81cd7f0f9876af424394e116fcfab1d1f704221eb38401ead6467626e0f11424"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b476cd5a748daced1b8bca3f90ca91048987a153d817f5a75f4e8dc66a2b4ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56963b9e510cb3ed4fae100dcb3f8d8873598b753c39e81a30f4aa525883e4cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5cf3cf50d01bd31207b7a687a305ba24acbe8944567f15d880f3c54355f9960a"
  end

  depends_on "python@3.14"

  pypi_packages package_name: "xonsh[ptk,pygments,proctitle]"

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/8d/48/49393a96a2eef1ab418b17475fb92b8fcfad83d099e678751b05472e69de/setproctitle-1.3.7.tar.gz"
    sha256 "bc2bc917691c1537d5b9bca1468437176809c7e11e5694ca79a9ca12345dcb9e"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/c2/62/a7c072fbfefb2980a00f99ca994279cb9ecf310cb2e6b2a4d2a28fe192b3/wcwidth-0.5.3.tar.gz"
    sha256 "53123b7af053c74e9fe2e92ac810301f6139e64379031f7124574212fb3b4091"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end