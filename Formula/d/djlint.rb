class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/5c/aa/3ade035e216087d93eb1f07e82dd63280261e20f391f6f3ca10e903da06f/djlint-1.39.3.tar.gz"
  sha256 "6d410cc25446589aeb387168e026f66840619c98829a8ff60abebd51126f719e"
  license "GPL-3.0-or-later"
  head "https://github.com/djlint/djLint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "45efee55f18bfc6b9ce79314b7a21c18d46ea8a3e24a4cfad79334d5c10e4d77"
    sha256 cellar: :any, arm64_sequoia: "5c62edd3e3f0ecb2ff0b232b8f9f6aaecdd1a324af80aeecbda229ec96e5662a"
    sha256 cellar: :any, arm64_sonoma:  "326be4bcb848ba01bce6c4bde784fb8bdb9fe034b3eab59fbffd3b40cfd85627"
    sha256 cellar: :any, sonoma:        "68b4ffed4bc198c7e481fa486aa85211a818ea299493c860e79806a286d2f80a"
    sha256 cellar: :any, arm64_linux:   "92635719fe7b2c6f77042fb2c2ed7af24e20d15db9bc7ddfab052f14e4ac456e"
    sha256 cellar: :any, x86_64_linux:  "b87873c56972b4feca28a9a63cecb33a5208857b2f476b2ca86e955eb07611d6"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "cssbeautifier" do
    url "https://files.pythonhosted.org/packages/7b/dc/05e09a3cdacaeb73350442dfef37b9e22f764a076636df70e6d4c779c2a9/cssbeautifier-2.0.1.tar.gz"
    sha256 "f6102c0589c85be3c1a016cee76ee3661ee4bd5da88d48a5f8708bfaf663ae26"
  end

  resource "editorconfig" do
    url "https://files.pythonhosted.org/packages/88/3a/a61d9a1f319a186b05d14df17daea42fcddea63c213bcd61a929fb3a6796/editorconfig-0.17.1.tar.gz"
    sha256 "23c08b00e8e08cc3adcddb825251c497478df1dada6aefeb01e626ad37303745"
  end

  resource "jsbeautifier" do
    url "https://files.pythonhosted.org/packages/48/a4/6283089b46c2bd895f5c4b223456167ea859ce54fed01f4c1ee4e8a8ed20/jsbeautifier-2.0.1.tar.gz"
    sha256 "45603b2097410feee8d3a6ef8ad5a8e0a0e89f347331888a97e46f332ce8d953"
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
    url "https://files.pythonhosted.org/packages/dc/0e/49aee608ad09480e7fd276898c99ec6192985fa331abe4eb3a986094490b/regex-2026.5.9.tar.gz"
    sha256 "a8234aa23ec39894bfe4a3f1b85616a7032481964a13ac6fc9f10de4f6fca270"
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