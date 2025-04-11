class Otterdog < Formula
  include Language::Python::Virtualenv

  desc "Manage GitHub organizations at scale using an infrastructure as code approach"
  homepage "https:otterdog.readthedocs.ioenlatest"
  url "https:files.pythonhosted.orgpackagesccc5ae5923a20f4f6e6b6ee84e6823260329bcef0abc84a0fba19fd4ae43de77otterdog-1.0.1.tar.gz"
  sha256 "41e98eb61f27526abd0f05609f3397523ce8351997936dd294f3445df8a40f58"
  license "EPL-2.0"
  head "https:github.comeclipse-csiotterdog.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d5471ae37492083ace8f440f014a2d66909c4025541e381f6c4333c63db046ed"
    sha256 cellar: :any,                 arm64_sonoma:  "9b652394f3b555afd613331902723f5342237f945b9c02670a2266e3afc121d5"
    sha256 cellar: :any,                 arm64_ventura: "4ff3a985053672dadc3fbbb268ebbc5cf8d2cb8c407834579dd589cc48d064f1"
    sha256 cellar: :any,                 sonoma:        "0e698daa04fd332f75aa560cdcae53c38c145cdef5841b8929dfb1e3ae01d99c"
    sha256 cellar: :any,                 ventura:       "a7f9fe2c25ddcee2c4ed68b163dde89088588292fc2fd7196a4ff9200c28899d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97a80bf433f8f13a68a00a74728ade22f373053e84b7cba7736cff0282cb7daa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ef9ed3d0e651c688420e689c931fa5edc50c629ee8222fa554395ca27f4ee57a"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "libsodium"
  depends_on "python@3.13"

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackages0b03a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesf1d91c4721d143e14af753f2bf5e3b681883e1f24b592c0482df6fa6e33597faaiohttp-3.11.16.tar.gz"
    sha256 "16f8a2c9538c14a557b4d309ed4d0a7c60f0253e8ed7b6c9a2859a7582f8b1b8"
  end

  resource "aiohttp-client-cache" do
    url "https:files.pythonhosted.orgpackagesfc6b2c09e4a0dd7d8f1b23ad0afac1ebdb200ed59445057f6caca3f653e7510aaiohttp_client_cache-0.13.0.tar.gz"
    sha256 "dc5cd62340adbee18e0fedc7b0c37542692df08f8ed9945d751b7292a0433853"
  end

  resource "aiohttp-retry" do
    url "https:files.pythonhosted.orgpackages9d61ebda4d8e3d8cfa1fd3db0fb428db2dd7461d5742cea35178277ad180b033aiohttp_retry-2.9.1.tar.gz"
    sha256 "8eb75e904ed4ee5c2ec242fefe85bf04240f685391c4879d8f541d6028ff01f1"
  end

  resource "aioshutil" do
    url "https:files.pythonhosted.orgpackages75e4ef86f1777a9bc0c51d50487b471644ae20941afe503591d3a4c86e456dacaioshutil-1.5.tar.gz"
    sha256 "2756d6cd3bb03405dc7348ac11a0b60eb949ebd63cdd15f56e922410231c1201"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "aiosqlite" do
    url "https:files.pythonhosted.orgpackages137d8bca2bf9a247c2c5dfeec1d7a5f40db6518f88d314b8bca9da29670d2671aiosqlite-0.21.0.tar.gz"
    sha256 "131bb8056daa3bc875608c631c678cda73922a2d4ba8aec373b19f18c17e7aa3"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "asyncer" do
    url "https:files.pythonhosted.orgpackagesff677ea59c3e69eaeee42e7fc91a5be67ca5849c8979acac2b920249760c6af2asyncer-0.0.8.tar.gz"
    sha256 "a589d980f57e20efb07ed91d0dbe67f1d2fd343e7142c66d3a099f05c620739c"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages16b0572805e227f01586461c80e0fd25d65a2115599cc9dad142fee4b747c357charset_normalizer-3.4.1.tar.gz"
    sha256 "44251f18cd68a75b56585dd00dae26183e102cd5e0f9f1466e6df5da2ed64ea3"
  end

  resource "chevron" do
    url "https:files.pythonhosted.orgpackages151fca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8fed0f4cec13a93c02c47ec32d81d11c0c1efbadf4a471e3f3ce7cad366cbbd3frozenlist-1.5.0.tar.gz"
    sha256 "81d5af29e61b9c8348e876d442253723928dce6433e0e76cd925cd83f1b4b817"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages729463b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320agitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesc08937df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-resources" do
    url "https:files.pythonhosted.orgpackagescf8cf834fbf984f691b4f7ff60f50b514cc3de5cc08abfc3295564dd89c5e2e7importlib_resources-6.5.2.tar.gz"
    sha256 "185f87adef5bcc288449d98fb4fba07cea78bc036455dd44c5fc4a2fe78fed2c"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages9ccb8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31ditsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jsonata-python" do
    url "https:files.pythonhosted.orgpackagesabd19455e5ef09044a550500b32ff276a30f44928ab84b2db9ef13352bffd154jsonata_python-0.5.3.tar.gz"
    sha256 "c83f45127f8dc45e5ca5f20fd8b8635f094ef6bbb2d203a75bdde11ffece61e2"
  end

  resource "jsonbender" do
    url "https:files.pythonhosted.orgpackages33bab89ab7fb6127eda78e6351568a80cb1e45c5c2c87c3e96df6e6e5a922b43JSONBender-0.9.3.tar.gz"
    sha256 "54c0503f9e2f9768b113c12ef3d9502da14f0c434853a515cbc9c20e21572538"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackages10db58f950c996c793472e336ff3655b13fbcf1e3b359dcf52dcf3ed3b52c352jsonschema_specifications-2024.10.1.tar.gz"
    sha256 "0f38b83639958ce1152d02a7f062902c41c8fd20d558b0c34344292d417ae272"
  end

  resource "jwt" do
    url "https:files.pythonhosted.orgpackagesad661e792aef36645b96271b4d27c2a8cc9fc7bbbaf06277a849b9e1a6360e6ajwt-1.3.1-py3-none-any.whl"
    sha256 "61c9170f92e736b530655e75374681d4fcca9cfa8763ab42be57353b2b203494"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mintotp" do
    url "https:files.pythonhosted.orgpackagesc0b4126c898d8bdd6d73ee702cf221ab8ddfb8c53db9bc101272542e478eba20mintotp-0.3.0.tar.gz"
    sha256 "d0f4db5edb38a7481120176a526e8c29539b9e80581dd2dcc1811557d77cfad5"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages79f25e10ba356eddf43b85b67df6fdd07dce882cc8479cfe434e97cc72603ac9multidict-6.4.2.tar.gz"
    sha256 "99f9b6596d2e126fa1777990868743fb4c1984ea5217606fabc153aff46160e6"
  end

  resource "playwright" do
    url "https:github.commicrosoftplaywright-pythonarchiverefstagsv1.51.0.tar.gz"
    sha256 "9c082490a1769eaa1ccb93786e1b1b1ef2257991dd1ab56056f8f4b9601ef85e"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackages07c8fdc6686a986feae3541ea23dcaa661bd93972d3940460646c6bb96e21c40propcache-0.3.1.tar.gz"
    sha256 "40d980c33765359098837527e18eddefc9a24cea5b45e078a7f3bb5b032c6ecf"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pynacl" do
    url "https:files.pythonhosted.orgpackagesa72227582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986daPyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages2fdb98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rjsonnet" do
    url "https:files.pythonhosted.orgpackages70654c6b1e4baf48ebbc6ff0c8cf8b50f08c63173d9abd5dd7f3af03b4bcd460rjsonnet-0.5.6.tar.gz"
    sha256 "47bd8f63b4b1def67f83001c07ff7d43d6a90dbf89cb6fb680c941db809a60ce"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages0bb352b213298a0ba7097c7ea96bee95e1947aa84cc816d48cebb539770cdf41rpds_py-0.24.0.tar.gz"
    sha256 "772cc1b2cd963e7e17e6cc55fe0371fb9c704d63e44cacec7b9b7f523b78919e"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages44cda040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3bsmmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "url-normalize" do
    url "https:files.pythonhosted.orgpackages1c94d79b960d66b933492f7dfbec8db799fa7033e7fbc98090f46fa581ca3a94url_normalize-2.2.0.tar.gz"
    sha256 "0f0b7cc95a95d2d9b0c9a51d47a326559bc05bd1558accdada21bb0c9504de85"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagesfc4d8a8f57caccce49573e567744926f88c6ab3ca0b47a257806d1cf88584c5fyarl-1.19.0.tar.gz"
    sha256 "01e02bb80ae0dbed44273c304095295106e1d9470460e773268a27d11e594892"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_PLAYWRIGHT"] = resource("playwright").version
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"otterdog", shell_parameter_format: :click, shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}otterdog --version")

    assert_match "File 'otterdog.json' does not exist", shell_output("#{bin}otterdog validate 2>&1", 2)
  end
end