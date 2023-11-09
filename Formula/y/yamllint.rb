class Yamllint < Formula
  include Language::Python::Virtualenv

  desc "Linter for YAML files"
  homepage "https://github.com/adrienverge/yamllint"
  url "https://files.pythonhosted.org/packages/29/50/fd0b7b1e1f36327521909236df2d6795baebc30b4a0cb943531ff6734eb7/yamllint-1.32.0.tar.gz"
  sha256 "d01dde008c65de5b235188ab3110bebc59d18e5c65fc8a58267cd211cd9df34a"
  license "GPL-3.0-or-later"
  revision 1
  head "https://github.com/adrienverge/yamllint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6454c1e0e92eba80b42363eca9d5014c7be7c9ed13bdaa88f55173004f1d9916"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a7abf3cce862588a1a676c9b0e944534684d2060886f4332cc6998294a389ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3468ef98c08c07d7478f31cb9ae49ed54ac5fdbcf3905542e7e912ccf39791d2"
    sha256 cellar: :any_skip_relocation, sonoma:         "01d3ba47d81a21a8b9b5b32dbd9f6908bf1ed8193e57e145a538ba8c65f4f49a"
    sha256 cellar: :any_skip_relocation, ventura:        "657ac949141a9b88ccdb6d2611995048c2c197e4e3cc3a36491d94dfc29e8183"
    sha256 cellar: :any_skip_relocation, monterey:       "25b06d8880bb048a2020b9033234dba944374008ebc24cbd9e0f8018c610ce93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "16358226a9b0c5cdcf88f68ad2a60f00cead61ceefe7257ce57955670cf13c22"
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