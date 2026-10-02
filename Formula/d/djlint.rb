class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/97/89/802575614cda0554b57e112c025a79729b50a0bcc32daaf4f8a989850d68/djlint-1.46.4.tar.gz"
  sha256 "5e05f356bf14a7ecd3d885867b5110e778dafba19640ef88e701c060f3a98a20"
  license "GPL-3.0-or-later"
  head "https://github.com/djlint/djLint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "87838d24c2dcd24f21b2765f3ecf764ae7683aa0658040f838349415be51400a"
    sha256 cellar: :any, arm64_tahoe:       "383d1e65b571f5444a5320bfa199e36962d5587fd8e72eb159ff26e827e691c3"
    sha256 cellar: :any, arm64_sequoia:     "6d90dc0409c97ce430e3e8d63ee747a7e93ae7439bade5b53310f836127bc9ba"
    sha256 cellar: :any, arm64_linux:       "e406b7806a8524addfc00422ed0731257987ab6f0af9145c08559668f62e29f8"
    sha256 cellar: :any, x86_64_linux:      "3c4c3914835f46f9ed17f1aba80ffe391ef45440a2fd2d5a6eff6f30dec9878e"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "cssbeautifier" do
    url "https://files.pythonhosted.org/packages/8f/b2/ed2890f0862fea7b79bb5224e22b2393376fdcd8f4b4e24dbbf1e9256d23/cssbeautifier-2.0.3.tar.gz"
    sha256 "2c2fd129342561029de86b1744efa231c9fafe26023dbc988a1deb0ca0f5c845"
  end

  resource "editorconfig" do
    url "https://files.pythonhosted.org/packages/88/3a/a61d9a1f319a186b05d14df17daea42fcddea63c213bcd61a929fb3a6796/editorconfig-0.17.1.tar.gz"
    sha256 "23c08b00e8e08cc3adcddb825251c497478df1dada6aefeb01e626ad37303745"
  end

  resource "jsbeautifier" do
    url "https://files.pythonhosted.org/packages/2e/81/e0e11e305caa89831a0c8e555638d588c28b426d1105e734e113b00efd5d/jsbeautifier-2.0.3.tar.gz"
    sha256 "9579d4e9dbaa00383f3efdff4c98c8140bb85ba319398e8b97cdaba27abd6ba3"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/e4/7d/05c46a96a78147ae3bf99c2f4169ce144a70220b8d6fcd56f6ec368b8ce9/json5-0.15.0.tar.gz"
    sha256 "7424d1f1eb1d56da6e3d70643f53619862b4ce81440bdb8ecfd6f875e5ba4a71"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/5a/82/42f767fc1c1143d6fd36efb827202a2d997a375e160a71eb2888a925aac1/pathspec-1.1.1.tar.gz"
    sha256 "17db5ecd524104a120e173814c90367a96a98d07c45b2e10c2f3919fff91bf5a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"djlint", shell_parameter_format: :click)
  end

  test do
    assert_includes shell_output("#{bin}/djlint --version"), version.to_s

    (testpath/"test.html").write <<~HTML
      {% load static %}<!DOCTYPE html>
    HTML

    output = shell_output("#{bin}/djlint --reformat --no-github-output #{testpath}/test.html", 1)
    assert_match "1 file was updated.", output
  end
end