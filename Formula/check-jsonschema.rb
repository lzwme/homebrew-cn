class CheckJsonschema < Formula
  include Language::Python::Virtualenv

  desc "JSON Schema CLI"
  homepage "https://github.com/python-jsonschema/check-jsonschema"
  url "https://files.pythonhosted.org/packages/91/d7/0e031767feed17a18e38d75ff3cd255fb2257c625bc213ee8ea796d21577/check-jsonschema-0.23.3.tar.gz"
  sha256 "6b174599b5f1a208e7b22b3d1698708a6d948a2a90ab3413a025e5c0217ee056"
  license "Apache-2.0"
  head "https://github.com/python-jsonschema/check-jsonschema.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "10673a4fad8f4266a6ca8e9627d4414bad4a00539305e198c6ebc03e16b2e969"
    sha256 cellar: :any,                 arm64_monterey: "45883052ccc9bc2f092224f2edc77a50c25c17e4b888165471cd2a71ecd9ed1b"
    sha256 cellar: :any,                 arm64_big_sur:  "c2a612a28bf631eeaa84f490f952563a9ca84a9fbd4a4e5a39d289ecd8344382"
    sha256 cellar: :any,                 ventura:        "d1e35ec4ba0b839ac4f6a594ba6c9c9b022af02cfcb237e7f7d6ddf0e5cf442c"
    sha256 cellar: :any,                 monterey:       "f6a51ec59bb029119a9516d163fb283cf93542e840a8694ffbe2ea4b87002927"
    sha256 cellar: :any,                 big_sur:        "f6f51fa0975968b9529f7c9a5ca8804d04f9a467cfe34ce08c7a099594189d2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba4c2a3b9a2b1548fbb676aa3cf82341ad5f47f853d05807e0bda4f1ca44114d"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"
  depends_on "six"

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/77/88/b0cc5fe95c31c301e9823ea9b028f669c0dcfa205ff71111037a5ed4892c/click-8.1.4.tar.gz"
    sha256 "b97d0c74955da062a7d4ef92fadb583806a585b2ea81958a81bd72726cbb8e37"
  end

  resource "fqdn" do
    url "https://files.pythonhosted.org/packages/30/3e/a80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0/fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "isoduration" do
    url "https://files.pythonhosted.org/packages/7c/1a/3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91ead/isoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/79/01/ce65847f79de9594d436b7ef295e374dfcc0ff3ee884bf61cf896f970ddb/jsonschema-4.18.0.tar.gz"
    sha256 "8caf5b57a990a98e9b39832ef3cb35c176fe331414252b6e1b26fd5866f891a4"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/9a/8c/3d028449ac15cba52db3e1c95ca53b9240b4707fbe17f43e01cc73dd9336/jsonschema_specifications-2023.6.1.tar.gz"
    sha256 "ca1c4dd059a9e7b34101cf5b3ab7ff1d18b139f35950d598d629837ef66e8f28"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/20/93/45213b5b6e3eeab03e3f6eb82cc516a81fbf257586a25f9eb1d21af96e1b/referencing-0.29.1.tar.gz"
    sha256 "90cb53782d550ba28d2166ef3f55731f38397def8832baac5d45235f1995e35e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rfc3987" do
    url "https://files.pythonhosted.org/packages/14/bb/f1395c4b62f251a1cb503ff884500ebd248eed593f41b469f89caa3547bd/rfc3987-1.3.8.tar.gz"
    sha256 "d3c4d257a560d544e9826b38bc81db676890c79ab9d7ac92b39c7a253d5ca733"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e6/fe/7d07bc08cce2ccae2c7e5c96d9b3976c4e1fa5e248989dca0a58bc7628f8/rpds_py-0.8.10.tar.gz"
    sha256 "13e643ce8ad502a0263397362fb887594b49cf84bf518d6038c16f235f2bcea4"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/39/97/03674459c459b9b69ef71eba039205a72867e5c6c409df3136858f6836f3/ruamel.yaml-0.17.31.tar.gz"
    sha256 "098ed1eb6d338a684891a72380277c1e6fc4d4ae0e120de9a447275056dda335"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "uri-template" do
    url "https://files.pythonhosted.org/packages/31/c7/0336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64/uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  resource "webcolors" do
    url "https://files.pythonhosted.org/packages/a1/fb/f95560c6a5d4469d9c49e24cf1b5d4d21ffab5608251c6020a965fb7791c/webcolors-1.13.tar.gz"
    sha256 "c225b674c83fa923be93d235330ce0300373d02885cef23238813b0d5668304a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
      	"name" : "Eggs",
      	"price" : 34.99
      }
    EOS

    (testpath/"test.schema").write <<~EOS
      {
        "type": "object",
        "properties": {
            "price": {"type": "number"},
            "name": {"type": "string"}
        }
      }
    EOS

    out = shell_output("#{bin}/check-jsonschema --schemafile #{testpath}/test.schema #{testpath}/test.json")
    assert_match "ok -- validation done", out
  end
end