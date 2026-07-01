class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/b1/64/5de9a070a4eb90fe3e590d5d2feb5d8fc5cbc1a4982b33e4c083a04ef321/djlint-1.39.5.tar.gz"
  sha256 "07a74deb6d5e132723392635e2fe19de0546ac92e252ccddbe54d417862346e8"
  license "GPL-3.0-or-later"
  head "https://github.com/djlint/djLint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "747968fe3feba8588d18268c381c170beca7fdef9a05a29adeed33c0ebdc26df"
    sha256 cellar: :any, arm64_sequoia: "f4c7f823bf8d7a882402f26c62e9cc4e453c71c885e96ee0fc95ef9927009514"
    sha256 cellar: :any, arm64_sonoma:  "d7168636dc463e66b9125732992df0b6f584c572e36d8eca8cc0348175442cc7"
    sha256 cellar: :any, sonoma:        "dc003d0561dade28584b402cf6cd5dfdb5d738883af35435582ab2a5fc1c4b8d"
    sha256 cellar: :any, arm64_linux:   "9dd27d04c335c7d3aba46672a5eaef49d9876789d35dde6d957aa4d55bbec864"
    sha256 cellar: :any, x86_64_linux:  "a27ff0cde84edb5bb8dccfd0aea11c2cb80450e4c1fc890e651a4c3959d014af"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
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
    url "https://files.pythonhosted.org/packages/f1/05/e4f219230e11e774a6c9987d2ab0d0c6b8573e13a17e143d0015bee710ef/regex-2026.6.28.tar.gz"
    sha256 "3cb4b6c5cb3060cc31efdc1fbb27c25fb9b29044afd87e40601a1c4d9db54342"
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