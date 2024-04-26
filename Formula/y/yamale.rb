class Yamale < Formula
  include Language::Python::Virtualenv

  desc "Schema and validator for YAML"
  homepage "https:github.com23andMeYamale"
  url "https:files.pythonhosted.orgpackages4b0739d5ea2304416b2c904f09340378fcc357c375e75b89f8945d7f5f629189yamale-5.2.0.tar.gz"
  sha256 "a411f24cc04e509e665773d23981d9573b93b31c296fbc1a09ec74a50f5d26ce"
  license "MIT"
  head "https:github.com23andMeYamale.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "86e8441bed2421f92b0e33f38381c38f94c8bf89891f761d83a6fd5a9a6af543"
    sha256 cellar: :any,                 arm64_ventura:  "24b7cd974bf282439ea42ce57b5d03f8a0adce42472076716033d93d48754858"
    sha256 cellar: :any,                 arm64_monterey: "78b6201b59d6992269b03935db82bef92c19ce0bad79d827a40177a88da36f66"
    sha256 cellar: :any,                 sonoma:         "69499bfe21c29fc48aa697b3902d0b552f32196ac9035904a50fddd71071226a"
    sha256 cellar: :any,                 ventura:        "4c074cdbdd07af51da7d50369efc06c7b408dfdeed75f27f41fa0aa4140113c0"
    sha256 cellar: :any,                 monterey:       "56d69ec847c5ae5a414e3df35424e3c9d61e7de7c6171c523355a83c47c1375f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92ec65b18d247eb3d8db4343d9b867cf1d1af5b00734976e3f2a30faf8025af2"
  end

  depends_on "libyaml"
  depends_on "python@3.12"

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"schema.yaml").write <<~EOS
      string: str()
      number: num(required=False)
      datetime: timestamp(min='2010-01-01 0:0:0')
    EOS
    (testpath"data1.yaml").write <<~EOS
      string: bo is awesome
      datetime: 2011-01-01 00:00:00
    EOS
    (testpath"some_data.yaml").write <<~EOS
      string: one
      number: 3
      datetime: 2015-01-01 00:00:00
    EOS
    output = shell_output("#{bin}yamale -s schema.yaml data1.yaml")
    assert_match "Validation success!", output

    output = shell_output("#{bin}yamale -s schema.yaml some_data.yaml")
    assert_match "Validation success!", output

    (testpath"good.yaml").write <<~EOS
      ---
      foo: bar
    EOS
    output = shell_output("#{bin}yamale -s schema.yaml schema.yaml", 1)
    assert_match "Validation failed!", output
  end
end