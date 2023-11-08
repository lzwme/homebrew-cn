class Csvkit < Formula
  include Language::Python::Virtualenv

  desc "Suite of command-line tools for converting to and working with CSV"
  homepage "https://csvkit.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/3d/92/012868ef113298afd9620f281351218211347ddbb55fb17bea7f3ce9dacd/csvkit-1.3.0.tar.gz"
  sha256 "b82e6ae2d2bb416517100ecbae8d5d856a0dffae42b712088814a2b7201e1af8"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97ee3801b05a0e37b1f14c6f52c607576c21312c18f7ecf780d033628dd96a93"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6764e18f88804f322658408eaf415f41fdc2ad0769ac7c3715331e91d4847d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b53c9154254e022e001ad2134ea0a63d4dd6cea5446fe14cdad8a8d04ced39a6"
    sha256 cellar: :any_skip_relocation, sonoma:         "30e5ce573d4bbe09c7f4e2cb79898131ba8a07cb39650a2344b07206190f0954"
    sha256 cellar: :any_skip_relocation, ventura:        "bdacb9a6dd39e8aab58089b369776ec349a4e23d4314a5c3b07f48f4352fda96"
    sha256 cellar: :any_skip_relocation, monterey:       "d9b0a8f84478acffea76489661a521a8e881b14ddc79ccf86f31e71708077b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2c3729a51afb8c010123fff0e7b8c4d82e4e8c3d6b6150b932dabfb795b764e1"
  end

  depends_on "python-pytz"
  depends_on "python-typing-extensions"
  depends_on "python@3.12"
  depends_on "six"

  resource "agate" do
    url "https://files.pythonhosted.org/packages/61/e4/40decc7f8c851281e7196a89170a7560ae3bae7b2dd7c3f44fd75eac6ff5/agate-1.9.0.tar.gz"
    sha256 "901b65382da982cfb52912246fb0ff3457d3ac02b94fafd4b10b0bff3ec358c5"
  end

  resource "agate-dbf" do
    url "https://files.pythonhosted.org/packages/54/70/a32dfaa47cb7b4e4d70aff67d89c32984085b946442d26a9d9fca7d96d8b/agate-dbf-0.2.2.tar.gz"
    sha256 "589682b78c5c03f2dc8511e6e3edb659fb7336cd118e248896bb0b44c2f1917b"
  end

  resource "agate-excel" do
    url "https://files.pythonhosted.org/packages/7c/85/f74ba95d9b4d53ffab0e17a1133d5e5f8c1910f4b48f9f7c116f3bf0c1c8/agate-excel-0.2.5.tar.gz"
    sha256 "62315708433108772f7f610ca769996b468a4ead380076dbaf6ffe262831b153"
  end

  resource "agate-sql" do
    url "https://files.pythonhosted.org/packages/3c/43/f9bcdc629d6d564dff6b962a2d4e8cac4589bcadc03044977ee4db18bbc6/agate-sql-0.7.0.tar.gz"
    sha256 "bb21e491cdcacee62e94eb6877d2a41d09accd58769abac238bc2f42de894cc9"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/d5/7d/08e7b8b1ab446121ace3de332f144be41a52049a23303375a0126d515cb7/Babel-2.13.0.tar.gz"
    sha256 "04c3e2d28d2b7681644508f836be388ae49e0cfe91465095340395b60d00f210"
  end

  resource "dbfread" do
    url "https://files.pythonhosted.org/packages/ad/ae/a5891681f5012724d062a4ca63ec2ff539c73d5804ba594e7e0e72099d3f/dbfread-2.0.7.tar.gz"
    sha256 "07c8a9af06ffad3f6f03e8fe91ad7d2733e31a26d2b72c4dd4cfbae07ee3b73d"
  end

  resource "et-xmlfile" do
    url "https://files.pythonhosted.org/packages/3d/5d/0413a31d184a20c763ad741cc7852a659bf15094c24840c5bdd1754765cd/et_xmlfile-1.1.0.tar.gz"
    sha256 "8eb9e2bc2f8c97e37a2dc85a09ecdcdec9d8a396530a6d5a33b30b9a92da0c5c"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/b6/02/47dbd5e1c9782e6d3f58187fa10789e308403f3fc3a490b3646b2bff6d9f/greenlet-3.0.0.tar.gz"
    sha256 "19834e3f91f485442adc1ee440171ec5d9a4840a1f7bd5ed97833544719ce10b"
  end

  resource "isodate" do
    url "https://files.pythonhosted.org/packages/db/7a/c0a56c7d56c7fa723988f122fa1f1ccf8c5c4ccc48efad0d214b49e5b1af/isodate-0.6.1.tar.gz"
    sha256 "48c5881de7e8b0a0d648cb024c8062dc84e7b840ed81e864c7614fd3c127bde9"
  end

  resource "leather" do
    url "https://files.pythonhosted.org/packages/73/c5/5bc5a19a62147ee8ff2de7b416ee6534b5bd79f22c790d0365ebef223f34/leather-0.3.4.tar.gz"
    sha256 "b43e21c8fa46b2679de8449f4d953c06418666dc058ce41055ee8a8d3bb40918"
  end

  resource "olefile" do
    url "https://files.pythonhosted.org/packages/34/81/e1ac43c6b45b4c5f8d9352396a14144bba52c8fec72a80f425f6a4d653ad/olefile-0.46.zip"
    sha256 "133b031eaf8fd2c9399b78b8bc5b8fcbe4c31e85295749bb17a87cba8f3c3964"
  end

  resource "openpyxl" do
    url "https://files.pythonhosted.org/packages/42/e8/af028681d493814ca9c2ff8106fc62a4a32e4e0ae14602c2a98fc7b741c8/openpyxl-3.1.2.tar.gz"
    sha256 "a6f5977418eff3b2d5500d54d9db50c8277a368436f4e4f8ddb1be3422870184"
  end

  resource "parsedatetime" do
    url "https://files.pythonhosted.org/packages/a8/20/cb587f6672dbe585d101f590c3871d16e7aec5a576a1694997a3777312ac/parsedatetime-2.6.tar.gz"
    sha256 "4cb368fbb18a0b7231f4d76119165451c8d2e35951455dfee97c62a87b04d455"
  end

  resource "python-slugify" do
    url "https://files.pythonhosted.org/packages/de/63/0f60208d0d3dde1a87d30a82906fa9b00e902b57f1ae9565d780de4b41d1/python-slugify-8.0.1.tar.gz"
    sha256 "ce0d46ddb668b3be82f4ed5e503dbc33dd815d83e2eb6824211310d3fb172a27"
  end

  resource "pytimeparse" do
    url "https://files.pythonhosted.org/packages/37/5d/231f5f33c81e09682708fb323f9e4041408d8223e2f0fb9742843328778f/pytimeparse-1.1.8.tar.gz"
    sha256 "e86136477be924d7e670646a98561957e8ca7308d44841e21f5ddea757556a0a"
  end

  resource "sqlalchemy" do
    url "https://files.pythonhosted.org/packages/ae/e2/47f40dc06472df5a906dd8eb9fe4ee2eb1c6b109c43545708f922b406acc/SQLAlchemy-2.0.22.tar.gz"
    sha256 "5434cc601aa17570d79e5377f5fd45ff92f9379e2abed0be5e8c2fba8d353d2b"
  end

  resource "text-unidecode" do
    url "https://files.pythonhosted.org/packages/ab/e2/e9a00f0ccb71718418230718b3d900e71a5d16e701a3dae079a21e9cd8f8/text-unidecode-1.3.tar.gz"
    sha256 "bad6603bb14d279193107714b288be206cac565dfa49aa5b105294dd5c4aab93"
  end

  resource "xlrd" do
    url "https://files.pythonhosted.org/packages/a6/b3/19a2540d21dea5f908304375bd43f5ed7a4c28a370dc9122c565423e6b44/xlrd-2.0.1.tar.gz"
    sha256 "f72f148f54442c6b056bf931dbc34f986fd0c3b0b6b5a58d013c9aef274d0c88"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "2,6", pipe_output("#{bin}/csvcut -c 1,3", "2,4,6,8", 0).chomp
  end
end