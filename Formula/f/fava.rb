class Fava < Formula
  include Language::Python::Virtualenv

  desc "Web interface for the double-entry bookkeeping software Beancount"
  homepage "https:beancount.github.iofava"
  url "https:files.pythonhosted.orgpackages6ea093e702e3ff56b058539f0ad62b6df6a8d8d00aba1c0b393aeccb277a25d4fava-1.30.1.tar.gz"
  sha256 "ebd5b1f7f1fb9cb0cf64ff4b3949c3267818f584c272bfa843413afb178858f1"
  license "MIT"
  revision 1
  head "https:github.combeancountfava.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "2a40103331ad97301f87a7548dc1d58b5a397e8bdbccfda31408bef2bf786de9"
    sha256 cellar: :any,                 arm64_sonoma:  "b91a203ab893b195f38a0fec13cde84e83e2c27b9e5bcbc87369afe307674984"
    sha256 cellar: :any,                 arm64_ventura: "a7b743d3fc86c54650248694067d0198523eaa71119035e4edcca0abff6c1d20"
    sha256 cellar: :any,                 sonoma:        "250b3e3755b046ac688b8dcc35e56a7d6179d26ea30c716bc34acbdd7e107bec"
    sha256 cellar: :any,                 ventura:       "d522789b27b90118c85a5de8943c0ebd4c7e2beed17f598eb6a0ea9a3d467faa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "83c9c596f061041ccbd4eadf72763ddcee7a754417b5d618b195e8168c2539ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "313c09784dda3c14df2ca71fcea1ed38d4dd22a4701b53d7dfbb187aa49b8742"
  end

  depends_on "bison" => :build # for beancount
  depends_on "meson" => :build # for beancount
  depends_on "ninja" => :build # for beancount
  depends_on "rust" => :build # for watchfiles
  depends_on "certifi"
  depends_on "python@3.13"

  uses_from_macos "flex" => :build # for beancount
  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  on_linux do
    depends_on "patchelf" => :build # for beancount
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagesa373199a98fc2dae33535d6b8e8e6ec01f8c1d76c9adb096c6b7d64823038cdeanyio-4.8.0.tar.gz"
    sha256 "1d9fe889df5212298c0c0723fa20479d1b94883a2df44bd3897aa91083316f7a"
  end

  resource "babel" do
    url "https:files.pythonhosted.orgpackages7d6bd52e42361e1aa00709585ecc30b3f9684b3ab62530771402248b1b1d6240babel-2.17.0.tar.gz"
    sha256 "0c54cffb19f690cdcc52a3b50bcbf71e07a808d1c80d549f2459b9d2cf0afb9d"
  end

  resource "beancount" do
    url "https:files.pythonhosted.orgpackages93a6973010277d08f95ba3c6f4685010fe00c6858a136ed357c7e797a0ccbc04beancount-3.1.0.tar.gz"
    sha256 "1e70aba21fae648bc069452999d62c94c91edd7567f41697395c951be791ee0b"
  end

  resource "beangulp" do
    url "https:files.pythonhosted.orgpackages39e65b3307d3035439f60da4372395edec8261852a083278fdbf3a96df0e6395beangulp-0.2.0.tar.gz"
    sha256 "5c908c45c62c07c4efadd0b03d3cdd145ad3b5e2bab5f5f277e0093a5891241a"
  end

  resource "beanquery" do
    url "https:files.pythonhosted.orgpackagescd048d9f3a48065fbf3f58826e8ea08bff35710ea8d542ed04654e87ec7b7b94beanquery-0.1.0.tar.gz"
    sha256 "b69e099b8421b219bbcc3293af77e3c4ccad7ab25bf520fee48788672ffbf64a"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesf03cadaf39ce1fb4afdd21b611e3d530b183bb7759c9b673d60db0e347fd4439beautifulsoup4-4.13.3.tar.gz"
    sha256 "1bd32405dacc920b42b83ba01644747ed77456a65760e285fbc47633ceddaf8b"
  end

  resource "blinker" do
    url "https:files.pythonhosted.orgpackages21289b3f50ce0e048515135495f198351908d99540d69bfdc8c1d15b73dc55ceblinker-1.9.0.tar.gz"
    sha256 "b4ce2265a7abece45e7cc896e98dbebe6cead56bcf805a3d23136d145f5445bf"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackagesf30df7b6ab21ec75897ed80c17d79b15951a719226b9fababf1e40ea74d69079chardet-5.2.0.tar.gz"
    sha256 "1b3b6ff479a8c414bc3fa2c0852995695c4a026dcd6d0633b2dd092ca39c1cf7"
  end

  resource "cheroot" do
    url "https:files.pythonhosted.orgpackages63e2f85981a51281bd30525bf664309332faa7c81782bb49e331af603421dbd1cheroot-10.0.1.tar.gz"
    sha256 "e0b82f797658d26b8613ec8eb563c3b08e6bd6a7921e9d5089bd1175ad1b1740"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "flask" do
    url "https:files.pythonhosted.orgpackages8950dff6380f1c7f84135484e176e0cac8690af72fa90e932ad2a0a60e28c69bflask-3.1.0.tar.gz"
    sha256 "5f873c5184c897c8d9d1b05df1e3d01b14910ce69607a117bd3277098a5836ac"
  end

  resource "flask-babel" do
    url "https:files.pythonhosted.orgpackages581a4c65e3b90bda699a637bfb7fb96818b0a9bbff7636ea91aade67f6020a31flask_babel-4.0.0.tar.gz"
    sha256 "dbeab4027a3f4a87678a11686496e98e1492eb793cbdd77ab50f4e9a2602a593"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages9ccb8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31ditsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackagesab239894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackageseff6c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "markdown2" do
    url "https:files.pythonhosted.orgpackages4452d7dcc6284d59edb8301b8400435fbb4926a9b0f13a12b5cbaf3a4a54bb7bmarkdown2-2.5.3.tar.gz"
    sha256 "4d502953a4633408b0ab3ec503c5d6984d1b14307e32b325ec7d16ea57524895"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages883b7fa1fe835e2e93fd6d7b52b2f95ae810cf5ba133e1845f726f5a992d62c2more-itertools-10.6.0.tar.gz"
    sha256 "2cd7fad1009c31cc9fb6a035108509e6547547a7a738374f10bd49a09eb3ee3b"
  end

  resource "ply" do
    url "https:files.pythonhosted.orgpackagese569882ee5c9d017149285cab114ebeab373308ef0f874fcdac9beb90e0ac4daply-3.11.tar.gz"
    sha256 "00c7c1aaa88358b9c765b6d3000c6eec0ba42abca5351b095321aef446081da3"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-magic" do
    url "https:files.pythonhosted.orgpackagesdadb0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  resource "pytz" do
    url "https:files.pythonhosted.orgpackages5f57df1c9157c8d5a05117e455d66fd7cf6dbc46974f832b1058ed4856785d8apytz-2025.1.tar.gz"
    sha256 "c2db42be2a2518b28e65f9207c4d05e6ff547d1efa4086469ef855e4ab70178e"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "simplejson" do
    url "https:files.pythonhosted.orgpackagesaf9251b417685abd96b31308b61b9acce7ec50d8e1de8fbc39a7fd4962c60689simplejson-3.20.1.tar.gz"
    sha256 "e64139b4ec4f1f24c142ff7dcafe55a22b811a74d86d66560c8815687143037d"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "tatsu" do
    url "https:files.pythonhosted.orgpackages09f6d53b45ea138e24199486e11deadedf06d0bedc9373911582b57a484f3d59TatSu-5.7.4.zip"
    sha256 "ebd8212323328115bc4967db9a40d7f15b627db4663290c64e5ef8fe71dca0ae"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "watchfiles" do
    url "https:files.pythonhosted.orgpackagesf526c705fc77d0a9ecdb9b66f1e2976d95b81df3cae518967431e7dbf9b5e219watchfiles-1.0.4.tar.gz"
    sha256 "6ba473efd11062d73e4f00c2b730255f9c1bdd73cd5f9fe5b5da8dbd4a717205"
  end

  resource "werkzeug" do
    url "https:files.pythonhosted.orgpackages9f6983029f1f6300c5fb2471d621ab06f6ec6b3324685a2ce0f9777fd4a8b71ewerkzeug-3.1.3.tar.gz"
    sha256 "60723ce945c19328679790e3282cc758aa4a6040e4bb330f53d30fa546d44746"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"fava", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    # Find an available port
    port = free_port

    (testpath"example.ledger").write <<~EOS
      2020-01-01 open Assets:Checking
      2020-01-01 open Equity:Opening-Balances
      2020-01-01 txn "Opening Balance"
        Assets:Checking 10.00 USD
        Equity:Opening-Balances
    EOS

    spawn bin"fava", "--port=#{port}", testpath"example.ledger"

    # Wait for fava to start up
    sleep 10

    cmd = "curl -sIm1 -XGET http:localhost:#{port}beancountincome_statement"
    assert_match(200 OKm, shell_output(cmd))
  end
end