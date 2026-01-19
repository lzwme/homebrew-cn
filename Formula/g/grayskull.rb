class Grayskull < Formula
  include Language::Python::Virtualenv

  desc "Recipe generator for Conda"
  homepage "https://github.com/conda/grayskull"
  url "https://files.pythonhosted.org/packages/a4/93/c24d673b719a346dfc7e905811737fb39d3cab82d22030f3a432c68899e8/grayskull-3.0.1.tar.gz"
  sha256 "cc7b1e93ea423e005c47b6d8fd525989a255f9c8d180b6ec90e11df86068af5f"
  license "Apache-2.0"
  head "https://github.com/conda/grayskull.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aeadc1f9dc569ea42ac54687c3ec203660b32c4f171eb3a49ea8ac1163a68916"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c042b17b403ef4036135646955e213fe8d70bacfc67a518728566089e26a4698"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbc290b972160f4a5e432fe9d0c9315aa252ffdd0789209e5af656b8a83d35e2"
    sha256 cellar: :any_skip_relocation, sonoma:        "12e3d973b1e502d50b2d11e07ac40550825534007a142772a5ff485aed7058f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1773b151769a8112107a6a08e7cde77988b24f3fb45e79bbb62d6907b73f6e1d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba63ef1810dbb81310961fd977329de1b9bf418696f77eb8e4c3232b43c36be8"
  end

  depends_on "cmake" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/c3/b0/1c6a16426d389813b48d95e26898aff79abbde42ad353958ad95cc8c9b21/beautifulsoup4-4.14.3.tar.gz"
    sha256 "6292b1c5186d356bba669ef9f7f051757099565ad9ada5dd630bd9de5fa7fb86"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "conda-souschef" do
    url "https://files.pythonhosted.org/packages/5b/bb/1d24463afd34bd572d4da1cae26a353925c8102241944d47c75b23321eb8/conda_souschef-3.0.1.tar.gz"
    sha256 "0df9fa12d826ab349e8006e498c6067b3a5161cf5b860baf08601829cb1b200b"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/24/03/e26bf3d6453b7fda5bd2b84029a426553bb373d6277ef6b5ac8863421f87/pkginfo-1.12.1.2.tar.gz"
    sha256 "5cd957824ac36f140260964eba3c6be6442a8359b8c48f4adf90210f33a04b7b"
  end

  resource "progressbar2" do
    url "https://files.pythonhosted.org/packages/19/24/3587e795fc590611434e4bcb9fbe0c3dddb5754ce1a20edfd86c587c0004/progressbar2-4.5.0.tar.gz"
    sha256 "6662cb624886ed31eb94daf61e27583b5144ebc7383a17bae076f8f4f59088fb"
  end

  resource "python-utils" do
    url "https://files.pythonhosted.org/packages/13/4c/ef8b7b1046d65c1f18ca31e5235c7d6627ca2b3f389ab1d44a74d22f5cc9/python_utils-3.9.1.tar.gz"
    sha256 "eb574b4292415eb230f094cbf50ab5ef36e3579b8f09e9f2ba74af70891449a0"
  end

  resource "rapidfuzz" do
    url "https://files.pythonhosted.org/packages/d3/28/9d808fe62375b9aab5ba92fa9b29371297b067c2790b2d7cda648b1e2f8d/rapidfuzz-3.14.3.tar.gz"
    sha256 "2491937177868bc4b1e469087601d53f925e8d270ccc21e07404b4b5814b7b5f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/c7/3b/ebda527b56beb90cb7652cb1c7e4f91f48649fbcd8d2eb2fb6e77cd3329b/ruamel_yaml-0.19.1.tar.gz"
    sha256 "53eb66cd27849eff968ebf8f0bf61f46cdac2da1d1f3576dd4ccee9b25c31993"
  end

  resource "ruamel-yaml-jinja2" do
    url "https://files.pythonhosted.org/packages/91/e0/ad199ab894f773551fc352541ce3305b9e7c366a4ae8c44ab1bc9ca3abff/ruamel.yaml.jinja2-0.2.7.tar.gz"
    sha256 "8449be29d9a157fa92d1648adc161d718e469f0d38a6b21e0eabb76fd5b3e663"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/93/f2/21d6ca70c3cf35d01ae9e01be534bf6b6b103c157a728082a5028350c310/soupsieve-2.8.2.tar.gz"
    sha256 "78a66b0fdee2ab40b7199dc3e747ee6c6e231899feeaae0b9b98a353afd48fd8"
  end

  resource "stdlib-list" do
    url "https://files.pythonhosted.org/packages/8c/25/f1540879c8815387980e56f973e54605bd924612399ace31487f7444171c/stdlib_list-0.12.0.tar.gz"
    sha256 "517824f27ee89e591d8ae7c1dd9ff34f672eae50ee886ea31bb8816d77535675"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  def install
    venv = virtualenv_install_with_resources without: "ruamel-yaml-jinja2"

    # Fix `ast` aliases removed in 3.14
    # Upstream has not been updated since 2021: https://sourceforge.net/projects/ruamel-yaml-jinja2/
    resource("ruamel-yaml-jinja2").stage do
      inreplace "setup.py" do |s|
        s.gsub!(/node\.(n|s)\b/, "node.value")
        s.gsub! "from ast import Str, Num, Bytes, NameConstant",
                "from ast import Constant; Str = Num = Bytes = NameConstant = Constant"
      end
      venv.pip_install Pathname.pwd
    end
  end

  test do
    assert_equal version, shell_output("#{bin}/grayskull --version").strip

    system bin/"grayskull", "pypi", "grayskull"
    assert_path_exists testpath/"grayskull/meta.yaml"
  end
end