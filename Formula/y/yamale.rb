class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https:github.com23andMeYamale"
  url "https:files.pythonhosted.orgpackagesc6a66bfdf3b84fe2db12e2fe900f9ab89b2a42f99764722c0f1174e99340b0bfyamale-5.3.0.tar.gz"
  sha256 "68af23b6155f496fb11c831a504eb9f9a474a997a8571d6f249dc044e6a65af3"
  license "MIT"
  head "https:github.com23andMeYamale.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "07cc752ebb1642a59d25612806c881c3f14f66b26e5ccc3d6e5605da9d3fa5f3"
    sha256 cellar: :any,                 arm64_sonoma:  "2b9ad0a42db9fcba7f763ca766d692418378648754c58c6ab042197b169299d2"
    sha256 cellar: :any,                 arm64_ventura: "25b04eda28ea49eaf9072e538ba53c9b58dc1a2382293274bd55f27a5e9fa980"
    sha256 cellar: :any,                 sonoma:        "6816a9ed83cd53f2a15ed1ba42ca6abd8838fb6aa69f82037a9681ed6369c3d5"
    sha256 cellar: :any,                 ventura:       "225d85d67aca1ff922ea84fa8b0dc3615d1fa947697b2b8887ed1dc09d3f3998"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "930b426c69d4075c6397f1f48121a7e335944afde00d579ed5071a528e657d2b"
  end

  depends_on "libyaml"
  depends_on "python@3.13"

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"schema.yaml").write <<~YAML
      string: str()
      number: num(required=False)
      datetime: timestamp(min='2010-01-01 0:0:0')
    YAML
    (testpath"data1.yaml").write <<~YAML
      string: bo is awesome
      datetime: 2011-01-01 00:00:00
    YAML
    (testpath"some_data.yaml").write <<~YAML
      string: one
      number: 3
      datetime: 2015-01-01 00:00:00
    YAML
    output = shell_output("#{bin}yamale -s schema.yaml data1.yaml")
    assert_match "Validation success!", output

    output = shell_output("#{bin}yamale -s schema.yaml some_data.yaml")
    assert_match "Validation success!", output

    (testpath"good.yaml").write <<~YAML
      ---
      foo: bar
    YAML
    output = shell_output("#{bin}yamale -s schema.yaml schema.yaml", 1)
    assert_match "Validation failed!", output
  end
end