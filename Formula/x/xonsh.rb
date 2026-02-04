class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  # xon.sh homepage bug report, https://github.com/xonsh/xonsh/issues/5984
  homepage "https://github.com/xonsh/xonsh"
  url "https://files.pythonhosted.org/packages/6a/1b/0298e083542044e9c8a5cf95bfae6f2ec90574dc8442982a12224cb00096/xonsh-0.22.2.tar.gz"
  sha256 "a3ceb8dc2111bb383e464b46b59e5a1d7811ee8d947d2227d64200d6788ff815"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "32adab3106834f02c9f9ad5c8d5f6783c88bb69723816c389bf6ba247ff229c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f9ee313c0bc7ecc53308faa4048a0d04af67bc386757934a46bc8d5fa2f24913"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "527b66b177142f65fc0360eb727cd062db8d2fd8d15466e82828f87313ab0468"
    sha256 cellar: :any_skip_relocation, sonoma:        "65da130544f79ad5490efd60ff83ee13d9b8b87e0af8de1c907e6d980fbc99a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "469000ee476f451784a620fdd6e1031dc76db0517900ede68e3cf518f152e1ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2dbdd9a84d396aaf14d7a1820c5b4e2444c0feba59c6e0a12dcfbfa32eb1383"
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