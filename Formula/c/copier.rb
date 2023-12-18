class Copier < Formula
  include Language::Python::Virtualenv

  desc "Utility for rendering projects templates"
  homepage "https:copier.readthedocs.io"
  url "https:files.pythonhosted.orgpackages626f399c09b6d1dcb30fc341402d81cc1eaa4f7aaa3ee65b5f58e68aff4635e7copier-9.1.0.tar.gz"
  sha256 "0810134f0bf3ce72b402480d1420ab7e773c1c9ce719a923e1584cb69f97dacb"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4d9b85e58add14339f35c8c520bd2a8eb12675a4f58d8088d827a5997582daf3"
    sha256 cellar: :any,                 arm64_ventura:  "5f6b543e3c7f4052207a55ea6de9fdb4b35a7216277625e9d2e866f6bde2d9d7"
    sha256 cellar: :any,                 arm64_monterey: "b7530b6dada0771a2ac75f5995243c53a0fdd9e7a267bfc2afd0fb7c2a51ff65"
    sha256 cellar: :any,                 sonoma:         "323a57f05f4fd3bab795b2648aa55b4e78a8cfd5bf08005744a0e6fd24122d4e"
    sha256 cellar: :any,                 ventura:        "cc147e856ac24bb3c134f673361fe397724c3d7e41303026f11a0e13c6aca7b6"
    sha256 cellar: :any,                 monterey:       "cc2df313eff91dc91f3d09a8979b452d72f06455d7bd2d93f671dd286a6b1f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90fd01187d33e2613e5de439098d721391f3f9f81d0de0a409a9dc135dd5947b"
  end

  depends_on "rust" => :build
  depends_on "pygments"
  depends_on "python-markupsafe"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "pyyaml"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackages67fe8c7b275824c6d2cd17c93ee85d0ee81c090285b6d52f4876ccc47cf9c3c4annotated_types-0.6.0.tar.gz"
    sha256 "563339e807e53ffd9c267e99fc6d9ea23eb8443c08f112651963e24e22f84a5d"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages660c8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dunamai" do
    url "https:files.pythonhosted.orgpackages1d03338fba56a6c76ea6d99ca0b7af3098292c2dd6597ed656daa6ae26a07a77dunamai-1.19.0.tar.gz"
    sha256 "6ad99ae34f7cd290550a2ef1305d2e0292e6e6b5b1b830dfc07ceb7fd35fec09"
  end

  resource "funcy" do
    url "https:files.pythonhosted.orgpackages70b8c6081521ff70afdff55cd9512b2220bbf4fa88804dae51d1b57b4b58ef32funcy-2.0.tar.gz"
    sha256 "3963315d59d41c6f30c04bc910e10ab50a3ac4a225868bfa96feed133df075cb"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackages7aff75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cceJinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jinja2-ansible-filters" do
    url "https:files.pythonhosted.orgpackages1a27fa186af4b246eb869ffca8ffa42d92b05abaec08c99329e74d88b2c46ec7jinja2-ansible-filters-1.3.2.tar.gz"
    sha256 "07c10cf44d7073f4f01102ca12d9a2dc31b41d47e4c61ed92ef6a6d2669b356b"
  end

  resource "pathspec" do
    url "https:files.pythonhosted.orgpackagesa02abd167cdf116d4f3539caaa4c332752aac0b3a0cc0174cdb302ee68933e81pathspec-0.11.2.tar.gz"
    sha256 "e0d8d0ac2f12da61956eb2306b69f9469b42f4deb0f3cb6ed47b9cce9996ced3"
  end

  resource "plumbum" do
    url "https:files.pythonhosted.orgpackages8e3d6bbc1b93fd394f6cc9fbe098d8e2740063d58c36dd8da876f790458ded46plumbum-1.8.2.tar.gz"
    sha256 "9e6dc032f4af952665f32f3206567bc23b7858b1413611afe603a3f8ad9bfd75"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesfb93180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesb7413c8108f79fb7da2d2b17f35744232af4ffcd9e764ebe1e3fd4b26669b325pydantic-2.5.2.tar.gz"
    sha256 "ff177ba64c6faf73d7afa2e8cad38fd456c0dbe01c9954e71038001cd15a6edd"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackages6426cffb93fe9c6b5a91c497f37fae14a4b073ecbc47fc36a9979c7aa888b245pydantic_core-2.14.5.tar.gz"
    sha256 "6d30226dfc816dd0fdf120cae611dd2215117e4f9b124af8c60ab9093b6e8e71"
  end

  resource "pyyaml-include" do
    url "https:files.pythonhosted.orgpackages45ecf730b826e22e4fad5f86f9130362b053ef970ac391baed22293e279128bepyyaml-include-1.3.1.tar.gz"
    sha256 "4cb3b4e1baae2ec251808fe1e8aed5d3d20699c541864c8e47ed866ab2f15039"
  end

  resource "questionary" do
    url "https:files.pythonhosted.orgpackages84d0d73525aeba800df7030ac187d09c59dc40df1c878b4fab8669bdc805535dquestionary-2.0.1.tar.gz"
    sha256 "bcce898bf3dbb446ff62830c86c5c6fb9a22a54146f0f5597d3da43b10d8fc8b"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackagesd71263deef355537f290d5282a67bb7bdd165266e4eca93cd556707a325e5a24wcwidth-0.2.12.tar.gz"
    sha256 "f01c104efdf57971bcb756f054dd58ddec5204dd15fa31d6503ea57947d97c02"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    params = %w[
      -d python=true
      -d js=true
      -d ansible=false
      -d biggest_kbs=1000
      -d main_branches=null
      -d github=true
    ]
    system bin"copier", "copy", *params, "--vcs-ref=v0.1.0",
      "https:github.comcopier-orgautopretty.git", "template"
    assert (testpath"template").directory?
    assert_predicate testpath"template.copier-answers.autopretty.yml", :exist?
  end
end