class Djlint < Formula
  include Language::Python::Virtualenv

  desc "Lint & Format HTML Templates"
  homepage "https://djlint.com"
  url "https://files.pythonhosted.org/packages/50/d8/119f35832801129dc6a4bdf82c163bb80d0095891eea9fc3543eaf8c9792/djlint-1.39.2.tar.gz"
  sha256 "dd27ef03bd26d1e0a167da26ec2a6fcb511dddd032b2553abf71a5c31eaa8b34"
  license "GPL-3.0-or-later"
  head "https://github.com/djlint/djLint.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a4ee7914e3c674f316a2bde81d32a30982d2072dc1ca5e307a0f24cca4b44e1d"
    sha256 cellar: :any, arm64_sequoia: "08b4f37a094c6c87ee2132c68cc12ce00f4f8bc2de2738283d8ccb64f8bcfe9a"
    sha256 cellar: :any, arm64_sonoma:  "6109259f7920ce238bdfe3038747d9db3ec33961cff26d766cbeed6be7c0b207"
    sha256 cellar: :any, sonoma:        "4b2e268191a992bf785e762b8ceb0bd0f573bafea395e0bd3e0f4de41ccdedee"
    sha256 cellar: :any, arm64_linux:   "94a806a46e2aa6baa8b5a3aa8ca74c25b093c37b45db7c1fddbe76a25da11258"
    sha256 cellar: :any, x86_64_linux:  "bd056a2b43bbc54b8ba0b3fa0995e21a63e0336dfa218f78d949ba50d77b1de7"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "cssbeautifier" do
    url "https://files.pythonhosted.org/packages/f7/01/fdf41c1e5f93d359681976ba10410a04b299d248e28ecce1d4e88588dde4/cssbeautifier-1.15.4.tar.gz"
    sha256 "9bb08dc3f64c101a01677f128acf01905914cf406baf87434dcde05b74c0acf5"
  end

  resource "editorconfig" do
    url "https://files.pythonhosted.org/packages/88/3a/a61d9a1f319a186b05d14df17daea42fcddea63c213bcd61a929fb3a6796/editorconfig-0.17.1.tar.gz"
    sha256 "23c08b00e8e08cc3adcddb825251c497478df1dada6aefeb01e626ad37303745"
  end

  resource "jsbeautifier" do
    url "https://files.pythonhosted.org/packages/ea/98/d6cadf4d5a1c03b2136837a435682418c29fdeb66be137128544cecc5b7a/jsbeautifier-1.15.4.tar.gz"
    sha256 "5bb18d9efb9331d825735fbc5360ee8f1aac5e52780042803943aa7f854f7592"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/9c/4b/6f8906aaf67d501e259b0adab4d312945bb7211e8b8d4dcc77c92320edaa/json5-0.14.0.tar.gz"
    sha256 "b3f492fad9f6cdbced8b7d40b28b9b1c9701c5f561bef0d33b81c2ff433fefcb"
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

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/85/05/0d5260f1f1ca784f4a4a0def9cbe6affe587f5b4025328d446c3d67765f4/tqdm-4.68.2.tar.gz"
    sha256 "89c230e8dbc67c7615c142487111222f878c77427ea09549960f62389e258add"
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