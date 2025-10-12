class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https://github.com/23andMe/Yamale"
  url "https://files.pythonhosted.org/packages/37/27/da3742a358015f3c2a069ccdaf7e5766ac358e8200319f640755db3128ae/yamale-6.0.0.tar.gz"
  sha256 "60be681f35e4939320b89de0d6f187ee0e5479ae7f7286b7f17f0859ddee4a66"
  license "MIT"
  head "https://github.com/23andMe/Yamale.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f9d30005e80962e774c7e09dadc03714a7d1dc9739a0b03dd4db55c868a00038"
    sha256 cellar: :any,                 arm64_sequoia: "381732e435c618369a90c067a4849f93a050deb6b2560859dd8a505aa7328a56"
    sha256 cellar: :any,                 arm64_sonoma:  "41f6168a4aad718a78cb334ead86b3ddf1ac580743405b2a6c95a7f031b052f7"
    sha256 cellar: :any,                 sonoma:        "badfaa6f0181fe03e824dc5e58e8175595ea994e6ac10cad8758ecf4d263b8ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "338157f7ebe70a91901b5ee3b813108d07d95f29eec95abfaf8b1fb0bff903c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8701f790dc3291171d806a101ff4dbeca5d359905921efd3de7a39012faf449c"
  end

  depends_on "libyaml"
  depends_on "python@3.14"

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/54/ed/79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17/pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"schema.yaml").write <<~YAML
      string: str()
      number: num(required=False)
      datetime: timestamp(min='2010-01-01 0:0:0')
    YAML
    (testpath/"data1.yaml").write <<~YAML
      string: bo is awesome
      datetime: 2011-01-01 00:00:00
    YAML
    (testpath/"some_data.yaml").write <<~YAML
      string: one
      number: 3
      datetime: 2015-01-01 00:00:00
    YAML
    output = shell_output("#{bin}/yamale -s schema.yaml data1.yaml")
    assert_match "Validation success!", output

    output = shell_output("#{bin}/yamale -s schema.yaml some_data.yaml")
    assert_match "Validation success!", output

    (testpath/"good.yaml").write <<~YAML
      ---
      foo: bar
    YAML
    output = shell_output("#{bin}/yamale -s schema.yaml schema.yaml", 1)
    assert_match "Validation failed!", output
  end
end