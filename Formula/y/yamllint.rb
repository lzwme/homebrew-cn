class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/fd/98/ec541c8dff395b9e441d46ab678c9a0f00f5ca479f070a6ced3b425cce79/yamllint-1.33.0.tar.gz"
  sha256 "2dceab9ef2d99518a2fcf4ffc964d44250ac4459be1ba3ca315118e4a1a81f7d"
  license "GPL-3.0-or-later"
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb95c1084cfdf23bae4d6f19ff4c2f7f45a65045ea0e11a9cd416ec2aab6d6bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7047a12ac719e84bb46eb93e12eb428f9d41a2ded009a4217b04729804821e65"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "131790bedd100c858de267a8dd360b8ab5120405ff624402fbf7e6514940ef9e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f57666cac0b223e7f7f438b6650fa0acf1c425d0b22c91f2228871e41b003db3"
    sha256 cellar: :any_skip_relocation, ventura:        "17e11e63beec9908ff6b0e8cb964d73a3a819dd73aa3c4903bb4eaa7ea5367af"
    sha256 cellar: :any_skip_relocation, monterey:       "aa8ad25a17a77c985e947851ab3ba9663e00a63d3b613c7c049b05f27f7ff446"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e00e468780f9ea7dbb9c8a7096e5955a8da043c95dff038b98e6a065212b3b05"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/a0/2a/bd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81/pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"bad.yaml").write <<~EOS
      ---
      foo: bar: gee
    EOS
    output = shell_output("#{bin}/yamllint -f parsable -s bad.yaml", 1)
    assert_match "syntax error: mapping values are not allowed here", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    assert_equal "", shell_output("#{bin}/yamllint -f parsable -s good.yaml")
  end
end