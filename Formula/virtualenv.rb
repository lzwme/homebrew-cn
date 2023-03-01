class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/e7/32/925d0ee72929865228d5160ec86c7967aea3f7f257f6f2226fcf08cc2352/virtualenv-20.20.0.tar.gz"
  sha256 "a8a4b8ca1e28f864b7514a253f98c1d62b64e31e77325ba279248c65fb4fcef4"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "265230a763d49724138d855e90aa0b59ca241a47a195b4f335d0537b6f792fc2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "214c2e49387ed883f1a08768de2e3ee44c4a0a9731f4df26525fa5ad3ed1d981"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bc14dd441f78307573b535a6ce5e7d5cf8298f2d91095fa329eb115a33171496"
    sha256 cellar: :any_skip_relocation, ventura:        "04d7babcad33f54fe9c96403533b5d49ca352247218a9b949ffc100fb2c35554"
    sha256 cellar: :any_skip_relocation, monterey:       "8784f872b44f3ce25ee406c040db1ca3a9ee0aaead4fe82817eaf773d8978893"
    sha256 cellar: :any_skip_relocation, big_sur:        "83815be6ba5db1c1c1e305982ebd8d5e02be1b4ea2a69d6e24daf993206c1511"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6042729a245ad951670a6ee1bceedceefeed89b8e0df15405d9b6853d4943873"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/11/39/702094fc1434a4408783b071665d9f5d8a1d0ba4dddf9dadf3d50e6eb762/platformdirs-3.0.0.tar.gz"
    sha256 "8a1228abb1ef82d788f74139988b137e78692984ec7b08eaa6c65f1723af28f9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end