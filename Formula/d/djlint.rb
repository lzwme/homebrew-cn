class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/97/89/802575614cda0554b57e112c025a79729b50a0bcc32daaf4f8a989850d68/djlint-1.46.4.tar.gz"
  sha256 "5e05f356bf14a7ecd3d885867b5110e778dafba19640ef88e701c060f3a98a20"
  license "GPL-3.0-or-later"
  head "https://github.com/djlint/djLint.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "66a83272f9ecbece3e6e7b33f2120709802c9d6a2f38e3190b94dfffdd36eea0"
    sha256 cellar: :any, arm64_tahoe:       "77512ded4eeee16b4d5a9c97d42c7d2414f5c35561280befc3b9d5af9a50c189"
    sha256 cellar: :any, arm64_sequoia:     "7a877975f2be608565a08f09e29752d673d0b02204a60c55cd1e2d9df5d62577"
    sha256 cellar: :any, arm64_linux:       "db0e46465bab1d07d159fbb31318428d6abc76f8e1cbcb010c707ec23a73c431"
    sha256 cellar: :any, x86_64_linux:      "c77f8d4c3069f60e7e152b81409b96f53b98b7ff3af8ef981042a07c482d0199"
  end

  depends_on "libyaml"
  depends_on "python@3.15"

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
    url "https://files.pythonhosted.org/packages/80/63/503651a3946bfacb6d6098985f2af6b3bf880d8eedc53035761c628d13bc/json5-0.16.0.tar.gz"
    sha256 "8b135a77b231f22e3656c601fec7621c5354c64c4fb2773715ee0814e4dc6bf7"
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