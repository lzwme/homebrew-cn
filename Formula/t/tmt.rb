class Tmt < Formula
  include Language::Python::Virtualenv

  desc "Test Management Tool"
  homepage "https://tmt.readthedocs.io"
  url "https://files.pythonhosted.org/packages/40/00/6653b20b631c46aaea216d48432f4498b31cbe72bcf4b6a9459832c9bbc5/tmt-1.64.0.tar.gz"
  sha256 "d358cf00ed6b7174335d03fe401312abd71a723ce4957cedac3b3ce941538026"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8cabe20a0e0f9afb14cebdf9a319f9bc82bd15d195035559cc854cbfcbab784e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "886fb781a616405233726a579e30ed910ae5b5c433f3afdf2d7910d49253edf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4f63da365373e7957979260c85e390230db8c065e4d2f6bd38eb995bc700036e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ae9daf2c7b3195791e8cd987ea07993b8655336c723e9f74cf8c727012d508b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c81efea8ae92d098aca053d1370d2737805066d85bd490580910ec1a6a44b926"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e44697bee809b82935c4b6a5cf99b011e46741d9707faf9ba27ac0cf6058216b"
  end

  depends_on "beakerlib"
  depends_on "certifi" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  pypi_packages exclude_packages: ["certifi", "pydantic", "rpds-py"]

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/3d/fa/656b739db8587d7b5dfa22e22ed02566950fbfbcdc20311993483657a5c0/click-8.3.1.tar.gz"
    sha256 "12ff4785d337a1bb490bb7e9c2b1ee5da3112e94a8622f26a6c77f5d2fc6842a"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/d9/02/111134bfeb6e6c7ac4c74594e39a59f6c0195dc4846afbeac3cba60f1927/docutils-0.22.3.tar.gz"
    sha256 "21486ae730e4ca9f622677b1412b879af1791efcfba517e4c6f60be543fc8cdd"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/a7/23/ce7a1126827cedeb958fc043d61745754464eb56c5937c35bbf2b8e26f34/filelock-3.20.1.tar.gz"
    sha256 "b8360948b351b80f420878d8516519a2204b07aefcdcfd24912a5d33127f188c"
  end

  resource "flexcache" do
    url "https://files.pythonhosted.org/packages/55/b0/8a21e330561c65653d010ef112bf38f60890051d244ede197ddaa08e50c1/flexcache-0.3.tar.gz"
    sha256 "18743bd5a0621bfe2cf8d519e4c3bfdf57a269c15d1ced3fb4b64e0ff4600656"
  end

  resource "flexparser" do
    url "https://files.pythonhosted.org/packages/82/99/b4de7e39e8eaf8207ba1a8fa2241dd98b2ba72ae6e16960d8351736d8702/flexparser-0.4.tar.gz"
    sha256 "266d98905595be2ccc5da964fe0a2c3526fbbffdc45b65b3146d75db992ef6b2"
  end

  resource "fmf" do
    url "https://files.pythonhosted.org/packages/2c/fe/aed3f3befc18d725776c10fe621790002671d0c4d50a6287d71fa371cf90/fmf-1.7.0.tar.gz"
    sha256 "131b557786b912f99d49d8dcc84196e3c2f39c5ce5ffe8b78e48150afd380dc3"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pint" do
    url "https://files.pythonhosted.org/packages/5f/74/bc3f671997158aef171194c3c4041e549946f4784b8690baa0626a0a164b/pint-0.25.2.tar.gz"
    sha256 "85a45d1da8fe9c9f7477fed8aef59ad2b939af3d6611507e1a9cbdacdcd3450a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/cf/86/0248f086a84f01b37aaec0fa567b397df1a119f73c16f6c7a9aac73ea309/platformdirs-4.5.1.tar.gz"
    sha256 "61d5cdcc6065745cdd94f0f878977f8de9437be93de97c1c12f853c9c0cdcbda"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3a/2b/7a1f1ebcd6b3f14febdc003e658778d81e76b40df2267904ee6b13f0c5c6/ruamel_yaml-0.18.17.tar.gz"
    sha256 "9091cd6e2d93a3a4b157ddb8fabf348c3de7f1fb1381346d985b6b247dcd8d3c"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/ea/97/60fda20e2fb54b83a61ae14648b0817c8f5d84a3821e40bfbdae1437026a/ruamel_yaml_clib-0.2.15.tar.gz"
    sha256 "46e4cc8c43ef6a94885f72512094e482114a8a706d3c555a34ed4b0d20200600"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1e/24/a2a2ed9addd907787d7aa0355ba36a6cadf1768b934c652ea78acbd59dcd/urllib3-2.6.2.tar.gz"
    sha256 "016f9c98bb7e98085cb2b4b17b87d2c702975664e4f060c6532e64d1c1a5e797"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"tmt", shell_parameter_format: :click)
  end

  test do
    output = shell_output("#{bin}/tmt init --template mini")
    assert_match "Applying template 'mini'", output
    assert_match <<~YAML, (testpath/"plans/example.fmf").read
      summary: Basic smoke test
      execute:
          how: tmt
          script: tmt --help
    YAML

    assert_match version.to_s, pipe_output("#{bin}/tmt --version")
  end
end