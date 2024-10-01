class Archey4 < Formula
  include Language::Python::Virtualenv

  desc "Simple system information tool written in Python"
  homepage "https:github.comHorlogeSkynetarchey4"
  url "https:files.pythonhosted.orgpackagesa7bdf70b613520c3f683eff6b9ffe5a31ba142bcc1b206db3181606b8e440193archey4-4.15.0.0.tar.gz"
  sha256 "1cf158ab799fa8a5d15deab0a48df306d2788c81de44d0242c3ab1dfa84865ac"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "314aba3d4c8073174d747aa1fb8e1545f314192cacfb645095b3d2a3e98fd3bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3ecfede2e3a95f640dccc8ab438b305106a136ff54d274a352345714583b658e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "745c57cc1d25ec22232f2f18dc749efab686a5f0e400b770619a077e57bb33f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "027039416868461c0677c8730ff9516c924bb4858bb550f72f03592a1283742b"
    sha256 cellar: :any_skip_relocation, ventura:       "fd17101816fd3161bab756c7b7e3de305e8ae842a5dfaca5bfa530f49fa5bdb2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8d615751b4231817a6ff3e3a04be453a8d187f1022d35a3979ec4529fc876f7"
  end

  depends_on "python@3.12"

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "netifaces" do
    url "https:files.pythonhosted.orgpackagesa69186a6eac449ddfae239e93ffc1918cf33fd9bab35c04d1e963b311e347a73netifaces-0.11.0.tar.gz"
    sha256 "043a79146eb2907edf439899f262b3dfe41717d34124298ed281139a8b93ca32"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match(version.to_s, shell_output("#{bin}archey -v"))
    assert_match(BSD|Linux|macOSi, shell_output("#{bin}archey -j"))
  end
end