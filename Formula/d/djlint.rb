class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/12/45/7e661eabd9356b2793c43cfa201d77a2e13aeca4af9295ad482b5f56d0b7/djlint-1.40.6.tar.gz"
  sha256 "68c2a4c2148a488ed4b7518bcb6ea13dd7a9202d78b35d69a43c04a7ded01d0f"
  license "GPL-3.0-or-later"
  head "https://github.com/djlint/djLint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "52ac4b781310e49b1638cc152f21ba8fe506cd5baf2122453a8ae5e3ece5cfe2"
    sha256 cellar: :any, arm64_sequoia: "494bf580c076b8658cf037efe5d7a3b30d85aafeb9b3de71270cc33f7ee397c0"
    sha256 cellar: :any, arm64_sonoma:  "1ac4b6e5187c651be2bdef61f5c428e58634d4c12cb3ead29ae10780949eba6e"
    sha256 cellar: :any, sonoma:        "9c0b4f29bce1c87ddd624f4694085af0b5362c7cc6057abfcfce18a9e1c768b4"
    sha256 cellar: :any, arm64_linux:   "c7bed525b2d686212b40c55f66d1731bae1fbd11bede1accbe265b7d6e353fd5"
    sha256 cellar: :any, x86_64_linux:  "bc4411cd156860ed5c9a8eed0010ccf28c5dd2d0e70e42b94194d60e8304e356"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/76/d4/81420972a676e8ffea40450d8c8c92943e7218a78fe9b64359836cc9876b/click-8.4.2.tar.gz"
    sha256 "9a6cea6e60b17ebe0a44c5cc636d94f09bd66142c1cd7d8b4cd731c4917a15f6"
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
    url "https://files.pythonhosted.org/packages/7b/37/451aaddbf50922f34d744ad5ca919ae1fcfac112123885d9728f52a484b3/regex-2026.7.10.tar.gz"
    sha256 "1050fedf0a8a92e843971120c2f57c3a99bea86c0dfa1d63a9fac053fe54b135"
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