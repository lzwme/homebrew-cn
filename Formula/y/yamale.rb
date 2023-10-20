class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/0c/93/3002a45542579cdd626a011f39bbe19ddcc1fbe0541081824c39ef216147/yamale-4.0.4.tar.gz"
  sha256 "e524caf71cbbbd15aa295e8bdda01688ac4b5edaf38dd60851ddff6baef383ba"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "13cf16b1397dcf4fe1fc1ec815659ee139b735762dc347f93cb0e864e6eb356f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "67cf985554522702e3731f60954f86512b4374eca4ba43c1daf69a1ed96f44e8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "523da70ce74bad88fa31f56469f4b4b1e64fd1875e992103d96d06c7994806f7"
    sha256 cellar: :any_skip_relocation, sonoma:         "0090dd33e507fd01e7d0c4232cf2f2b1f0b0e850de1ff3570c0e82b2c44b53c6"
    sha256 cellar: :any_skip_relocation, ventura:        "a83c010f6fd62bc432c4cbd1397865216dc13bd180369ce156a5574bd80e486e"
    sha256 cellar: :any_skip_relocation, monterey:       "714826b9590c809d794811f833dc8fe7a0cf1ec46e02bc40a8d1cfe33b26a334"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b3576332e4eb29d5360c9bb9d65d0c61e71dd09f5811673f001baba2139551"
  end

  depends_on "python@3.12"
  depends_on "pyyaml"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"schema.yaml").write <<~EOS
      string: str()
      number: num(required=False)
      datetime: timestamp(min='2010-01-01 0:0:0')
    EOS
    (testpath/"data1.yaml").write <<~EOS
      string: bo is awesome
      datetime: 2011-01-01 00:00:00
    EOS
    (testpath/"some_data.yaml").write <<~EOS
      string: one
      number: 3
      datetime: 2015-01-01 00:00:00
    EOS
    output = shell_output("#{bin}/yamale -s schema.yaml data1.yaml")
    assert_match "Validation success!", output

    output = shell_output("#{bin}/yamale -s schema.yaml some_data.yaml")
    assert_match "Validation success!", output

    (testpath/"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    output = shell_output("#{bin}/yamale -s schema.yaml schema.yaml", 1)
    assert_match "Validation failed!", output
  end
end