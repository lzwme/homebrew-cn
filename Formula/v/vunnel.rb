class Vunnel < Formula
  include Language::Python::Virtualenv

  desc "Tool for collecting vulnerability data from various sources"
  homepage "https:github.comanchorevunnel"
  url "https:files.pythonhosted.orgpackagesf683c65b3e981e20103d49b2b2d9404138d164066c3656657a90394f64ff8987vunnel-0.34.1.tar.gz"
  sha256 "cd6cedb3a039d794c25fdf61d686ae8bf669f0835b9b916b0da41704ad33ecf5"
  license "Apache-2.0"
  head "https:github.comanchorevunnel.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "27ce138645f26c327ccd6ce24e82394af42d72fc549831a7b4fc91c0cb04defa"
    sha256 cellar: :any,                 arm64_sonoma:  "e2f05505a7d5239ba418c0190dfccdecb925af1c8266bf8564a7aaa91168a6b9"
    sha256 cellar: :any,                 arm64_ventura: "0226b2bca0a7ba098e7d14622a48eb40ac23d58164329f2044e9a0f01f103ef9"
    sha256 cellar: :any,                 sonoma:        "398c56b01d16b22b1b3fbb3626799ab760c436ad61f89ca428e098461c34c314"
    sha256 cellar: :any,                 ventura:       "79a138fd90ed63563a98c737b7ad69ea35acc35ec8de9159f06f0519694115bb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aee4188e62464ca7771d65a40c22db22532198eeb97f293025bb2f95f1f75b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d4b3f6e309ad30797b3a82c6120540b78258a7e9b7bcd1bfb70da3383b41500"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
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
    url "https:files.pythonhosted.orgpackages4dcf63414dab3f513a18a3d1183ac3131d0f731bdaeffc125edcd3c08c2f2104cvss-3.4.tar.gz"
    sha256 "632353244ba3c58b53355466677edc968b9d7143c317b66271f9fd7939951ee8"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "docformatter" do
    url "https:files.pythonhosted.orgpackagesf705812faba28882695291c7dc61e64249081ee6394c9459987a6ce599c10ef5docformatter-1.5.0.tar.gz"
    sha256 "9dc71659d3b853c3018cd7b2ec34d5d054370128e12b79ee655498cb339cc711"
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
    url "https:files.pythonhosted.orgpackages7666650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "iniconfig" do
    url "https:files.pythonhosted.orgpackagesf297ebf4da567aa6827c909642694d71c9fcf53e5b504f2d96afea02718862f3iniconfig-2.1.0.tar.gz"
    sha256 "3abbd2e30b36733fee78f9c7f7308f2d0050e88f0087fd25c2645f63c773e1c7"
  end

  resource "iso8601" do
    url "https:files.pythonhosted.orgpackagesb9f3ef59cee614d5e0accf6fd0cbba025b93b272e626ca89fb70a3e9187c5d15iso8601-2.1.0.tar.gz"
    sha256 "6b1d3829ee8921c4301998c909f7829fa9ed3cbdac0d3b16af2d743aed1ba8df"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages763d14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08flxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mashumaro" do
    url "https:files.pythonhosted.orgpackagesd7924c1ac8d819fba3d6988876cadd922803818905a50d22d2027581366e8142mashumaro-3.16.tar.gz"
    sha256 "3844137cf053bbac30c4cbd0ee9984e839a5731a0ef96fd3dd9388359af3f2e1"
  end

  resource "mergedeep" do
    url "https:files.pythonhosted.orgpackages3a41580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "orjson" do
    url "https:files.pythonhosted.orgpackages810bfea456a3ffe74e70ba30e01ec183a9b26bec4d497f61dcfce1b601059c60orjson-3.10.18.tar.gz"
    sha256 "e8da3947d92123eda795b68228cafe2724815621fe35e8e320a9e9593a4bcd53"
  end

  resource "packageurl-python" do
    url "https:files.pythonhosted.orgpackagesa9b6d28c4fa7535530879e7d64176f7ff081fb6308b50cac8e30f038a89e8fddpackageurl_python-0.17.1.tar.gz"
    sha256 "5db592a990b60bc02446033c50fb1803a26c5124cd72c5a2cd1b8ea1ae741969"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackagesf9e23e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pytest" do
    url "https:files.pythonhosted.orgpackages08ba45911d754e8eba3d5a841a5ce61a65a685ff1798421ac054f85aa8747dfbpytest-8.4.1.tar.gz"
    sha256 "7c67fd69174877359ed9371ec3af8a3d2b04741818c51e5e99cc1742251fa93c"
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
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sqlalchemy" do
    url "https:files.pythonhosted.orgpackagesceaf20290b55d469e873cba9d41c0206ab5461ff49d759989b3fe65010f9d265sqlalchemy-1.4.54.tar.gz"
    sha256 "4470fbed088c35dc20b78a39aaf4ae54fe81790c783b3264872a0224f437c31a"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackages1887302344fed471e44a87289cf4967697d07e532f2421fdaf868a303cbae4fftomli-2.2.1.tar.gz"
    sha256 "cd45e1dc79c835ce60f7404ec8119f2eb06d38b1deba146f07ced3bbc44505ff"
  end

  resource "toposort" do
    url "https:files.pythonhosted.orgpackages69198e955d90985ecbd3b9adb2a759753a6840da2dff3c569d412b2c9217678btoposort-1.10.tar.gz"
    sha256 "bfbb479c53d0a696ea7402601f4e693c97b0367837c8898bc6471adfca37a6bd"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "untokenize" do
    url "https:files.pythonhosted.orgpackagesf746e7cea8159199096e1df52da20a57a6665da80c37fb8aeb848a3e47442c32untokenize-0.1.1.tar.gz"
    sha256 "3865dbbbb8efb4bb5eaa72f1be7f3e0be00ea8b7f125c69cbd1f5fda926f37a2"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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
    url "https:files.pythonhosted.orgpackagese3020f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  resource "zstandard" do
    url "https:files.pythonhosted.orgpackagesedf62ac0287b442160a89d726b17a9184a4c615bb5237db763791a7fd16d9df1zstandard-0.23.0.tar.gz"
    sha256 "b2d8c62d08e7255f68f7a740bae85b3c9b8e5466baa9cbf7f57f1cde0ac6bc09"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    # Fix compilation of ijson native extensions, note:
    # This would not be needed if latest ijson version is used upstream, but there are reasons it is
    # currently held back: https:github.comanchorevunnelpull103
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Fix python upper bound: https:github.comanchorevunnelissues809
    # upstream patch PR, https:github.comanchorevunnelpull823
    inreplace "pyproject.toml", "<=3.13,>=3.11", ">=3.11"
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"vunnel", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vunnel --version")

    assert_match "alpine", shell_output("#{bin}vunnel list")
  end
end