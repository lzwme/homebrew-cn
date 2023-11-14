class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/a2/58/e3068231c31198f9cd5198e2a0f1b3ac96c6f82f10c774ad61a0b4721b4b/pipgrip-0.10.9.tar.gz"
  sha256 "9bc0b74b89dc1ed9f05cc6066323d03bcc515cb2a58ca6717fe1c2db30c6b69b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55addb6f5484988dd0a7ff77b96dd0919db102382e831faf8960d464d202338b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fdf73145e562ddb95ecf2de9a29a23ea96cb10fead10656d57aa4e6aad1aa2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd0dccc7d8836030c0d054c2e7cd7958c8797ee2c2496dd2bd17caba7363d4d7"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c272e0bd604b2fa9c1e09bf2318ecba8996882919cd70a6e59ab866737bf47e"
    sha256 cellar: :any_skip_relocation, ventura:        "93ed28420b733ea27f307879f5468d9a4612200bf011b6169c5f28c26220bc12"
    sha256 cellar: :any_skip_relocation, monterey:       "13dd37fa4da8b95b0b2f374b91a647b5afd44aee8c8ef2b059bc6c3ad3dc7017"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5ed675110380eff721572de63fa7be2a4e87e5e26fe9b95d07d5b8fd98e1c01"
  end

  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python-setuptools"
  depends_on "python@3.12"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/7e/84/51e270f1f117da92025427e5cddd71ee62fc65de8b0391568055eb872d3d/anytree-2.12.0.tar.gz"
    sha256 "0dde0365cc8b1f3531e927694f39b903c360eadab2be09c50f3426ecca967949"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/fb/d0/0b4c18a0b85c20233b0c3bc33f792aefd7f12a5832b4da77419949ff6fd9/wheel-0.41.3.tar.gz"
    sha256 "4d4987ce51a49370ea65c0bfd2234e8ce80a12780820d9dc462597a6e60d0841"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"pipgrip", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end