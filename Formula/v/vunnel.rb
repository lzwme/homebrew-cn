class Vunnel < Formula
  include Language::Python::Virtualenv

  desc "Tool for collecting vulnerability data from various sources"
  homepage "https:github.comanchorevunnel"
  url "https:files.pythonhosted.orgpackagesfd2133fcc3d6e212e55e00bb1d2a0b8f58e78e05db1b4e8dac008f3a609e52a6vunnel-0.29.0.tar.gz"
  sha256 "59163b1017168f71ac2e442b35f4fa56ffa1af78869c54f12d6cf5e7352ac884"
  license "Apache-2.0"
  head "https:github.comanchorevunnel.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "8c3713972bc02a8f643ae6122dc3398f72f6a461b261145416dfdebb2bb9699e"
    sha256 cellar: :any,                 arm64_sonoma:  "b9525111f04d3ab9983c242f7b5c7376c03559fd4c8cd0eb9d8dfae5ad295bed"
    sha256 cellar: :any,                 arm64_ventura: "cf7986b2bb08febc02d0408259d0cdfb063e63bae506c5aff54fb0fd812e98a8"
    sha256 cellar: :any,                 sonoma:        "9bf9158616a81b5dbb4a1d9c0adcb7c24df6b50c7415e0920aec2a007c300579"
    sha256 cellar: :any,                 ventura:       "83c26694daf9c5448a0b5039d0153b6c253d9bed4b484a5e4685d1801823d745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "40f58b5700e38196225f1e207b3944b5c2043e2c20120f7478ddae5640d68581"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagesf24fe1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1echarset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https:files.pythonhosted.orgpackages1dceedb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41dfclick_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "colorlog" do
    url "https:files.pythonhosted.orgpackagesd37a359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "cvss" do
    url "https:files.pythonhosted.orgpackagesb8f38893d8c4ea780e51eb22bc94a5959a2836d7eb74fe7c24b98bd1b2c74d9ccvss-3.3.tar.gz"
    sha256 "ae097183ee58b02262ab2291d27857ca3d0a7c4242b9b076c6bf537e6239fbc0"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "docformatter" do
    url "https:files.pythonhosted.orgpackagesf705812faba28882695291c7dc61e64249081ee6394c9459987a6ce599c10ef5docformatter-1.5.0.tar.gz"
    sha256 "9dc71659d3b853c3018cd7b2ec34d5d054370128e12b79ee655498cb339cc711"
  end

  resource "greenlet" do
    url "https:files.pythonhosted.orgpackages2fffdf5fede753cc10f6a5be0931204ea30c35fa2f2ea7a35b25bdaf4fe40e46greenlet-3.1.1.tar.gz"
    sha256 "4ce3ac6cdb6adf7946475d7ef31777c26d94bccc377e070a7986bd2d5c515467"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ijson" do
    url "https:files.pythonhosted.orgpackagesd0123116e1d5752aa9d480eb58ae4b348d38c1aeaf792c5fbca22e44c27d4bf1ijson-2.6.1.tar.gz"
    sha256 "75ebc60b23abfb1c97f475ab5d07a5ed725ad4bd1f58513d8b258c21f02703d0"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackagescd1233e59336dca5be0c398a7482335911a33aa0e20776128f038019f1a95f1bimportlib_metadata-8.5.0.tar.gz"
    sha256 "71522656f0abace1d072b9e5481a48f07c138e00f079c38c8f883823f9c26bd7"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesd74bcbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "iso8601" do
    url "https:files.pythonhosted.orgpackagesb9f3ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackagese76b20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mashumaro" do
    url "https:files.pythonhosted.orgpackagesf3c17b687c8b993202e2eb49e559b25599d8e85f1b6d92ce676c8801226b8bdfmashumaro-3.15.tar.gz"
    sha256 "32a2a38a1e942a07f2cbf9c3061cb2a247714ee53e36a5958548b66bd116d0a9"
  end

  resource "mergedeep" do
    url "https:files.pythonhosted.orgpackages3a41580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackagese004bb9f72987e7f62fb591d6c880c0caaa16238e4e530cbc3bdc84a7372d75forjson-3.10.12.tar.gz"
    sha256 "0a78bbda3aea0f9f079057ee1ee8a1ecf790d4f1af88dd67493c6b8ee52506ff"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesd06368dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106dapackaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages962d02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages8b6c62bbd536103af674e227c41a8f3dcd022d591f6eed5facb5a0f31ee33bbcpytest-8.3.3.tar.gz"
    sha256 "70b98107bd648308a7952b06e6ca9a50bc660be218d53c257cc1fc94fda10181"
  end

  resource "pytest-snapshot" do
    url "https:files.pythonhosted.orgpackages9b7bab8f1fc1e687218aa66acec1c3674d9c443f6a2dc8cb6a50f464548ffa34pytest-snapshot-0.9.0.tar.gz"
    sha256 "c7013c3abc3e860f9feff899f8b4debe3708650d8d8242a61bf2625ff64db7f3"
  end

  resource "python-dateutil" do
    url "https:files.pythonhosted.orgpackages66c00c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6dbpython-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages7139171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85esix-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  resource "sqlalchemy" do
    url "https:files.pythonhosted.orgpackagesceaf20290b55d469e873cba9d41c0206ab5461ff49d759989b3fe65010f9d265sqlalchemy-1.4.54.tar.gz"
    sha256 "4470fbed088c35dc20b78a39aaf4ae54fe81790c783b3264872a0224f437c31a"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackages1ee41b6cbcc82d8832dd0ce34767d5c560df8a3547ad8cbc427f34601415930atomli-2.1.0.tar.gz"
    sha256 "3f646cae2aec94e17d04973e4249548320197cfabdf130015d023de4b74d8ab8"
  end

  resource "toposort" do
    url "https:files.pythonhosted.orgpackages69198e955d90985ecbd3b9adb2a759753a6840da2dff3c569d412b2c9217678btoposort-1.10.tar.gz"
    sha256 "bfbb479c53d0a696ea7402601f4e693c97b0367837c8898bc6471adfca37a6bd"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "untokenize" do
    url "https:files.pythonhosted.orgpackagesf746e7cea8159199096e1df52da20a57a6665da80c37fb8aeb848a3e47442c32untokenize-0.1.1.tar.gz"
    sha256 "3865dbbbb8efb4bb5eaa72f1be7f3e0be00ea8b7f125c69cbd1f5fda926f37a2"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "xsdata" do
    url "https:files.pythonhosted.orgpackages20130de81fd3e39c1c45125e5b79f8731f32b0a6d7556959a9a1aa87bcc43624xsdata-22.12.tar.gz"
    sha256 "a3d5f1b7b6fff8c916f7825c836ea285a4e7d3f3a94dcbbed0e63ba15dc94466"
  end

  resource "xxhash" do
    url "https:files.pythonhosted.orgpackages005ed6e5258d69df8b4ed8c83b6664f2b47d30d2dec551a29ad72a6c69eafd31xxhash-3.5.0.tar.gz"
    sha256 "84f2caddf951c9cbf8dc2e22a89d4ccf5d86391ac6418fe81e3c67d0cf60b45f"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackages3f50bad581df71744867e9468ebd0bcd6505de3b275e06f202c2cb016e3ff56fzipp-3.21.0.tar.gz"
    sha256 "2c9958f6430a2040341a52eb608ed6dd93ef4392e02ffe219417c1b28b5dd1f4"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackagesedf62ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    # Remove with next version, already fixed in
    # https:github.comanchorevunnelcommit2831a9a55c80f8d6ba31862219e68f796dde7455.patch
    inreplace "pyproject.toml" do |s|
      s.gsub! 'python = ">=3.11,<=3.13"', 'python = ">=3.11,<3.14"'
    end

    # Fix compilation of ijson native extensions, note:
    # This would not be needed if latest ijson version is used upstream, but there are reasons it is
    # currently held back: https:github.comanchorevunnelpull103
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    virtualenv_install_with_resources

    generate_completions_from_executable(bin"vunnel", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vunnel --version")

    assert_match "alpine", shell_output("#{bin}vunnel list")
  end
end