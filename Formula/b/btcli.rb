class Btcli < Formula
  include Language::Python::Virtualenv

  desc "Bittensor command-line tool"
  homepage "https:docs.bittensor.combtcli"
  url "https:files.pythonhosted.orgpackages579c12d9e44f81344776457753d4e386548c902b3b7cbd85bc17c3b75501a65ebittensor_cli-9.7.0.tar.gz"
  sha256 "dffef1dcc88a99cb3c1a95301b03efec70444dd83b1fa356c81fdfab3923c47f"
  license "MIT"
  head "https:github.comopentensorbtcli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e844c6d1a3c7bb3b9ff5af4fca25f5438b71839c3a84f78ed58c5a617d912db0"
    sha256 cellar: :any,                 arm64_sonoma:  "c5eed24e4219bcc2adf70ff68e0e1eec0e75acce55136c1fc63b41e7a14ffc49"
    sha256 cellar: :any,                 arm64_ventura: "113c276a6bbe8d4626f6904f0f771d5edae4a200639fc5e81d4a4ea844aab692"
    sha256 cellar: :any,                 sonoma:        "d4b6bbd4e954200a6479a630b8e6066d33b11b98d7b7b0382a7711026169d5da"
    sha256 cellar: :any,                 ventura:       "a7cb57fe1b9871c97fa5c9b7304377a76c6d09765bc0cc51fa41f4778cc85d14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a826f142833ea0404d54e01fbc9475f6bd39311d55208cc0f4b7219e55a7155"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2ce3b582f41045e786208e70027d684b63673d2799a9bfa4a615eb1643a7d39"
  end

  depends_on "cmake" => :build # for Levenshtein
  depends_on "maturin" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "certifi"
  depends_on "cffi"
  depends_on "cryptography"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python@3.13"
  depends_on "six"

  uses_from_macos "libffi"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages426eab88e7cb2a4058bed2f7870276454f85a7c56cd6da79349eb314fc7bbcaaaiohttp-3.12.13.tar.gz"
    sha256 "47e2da578528264a12e4e3dd8dd72a7289e5f812758fe086473fab037a10fcce"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "async-substrate-interface" do
    url "https:files.pythonhosted.orgpackages0e221754349acf82b9f65154d774bc32ac4c87f7da730a38be534a5d54c5ca70async_substrate_interface-1.3.1.tar.gz"
    sha256 "86dcfdeb94c7b8aab8ef3f870c23d6349c107ab853acc88c44fa1635a6792ef5"
  end

  resource "asyncstdlib" do
    url "https:files.pythonhosted.orgpackages50e172e388631c85233a2fd890d024fc20a8a9961dbba8614d78266636218f1fasyncstdlib-3.13.1.tar.gz"
    sha256 "f47564b9a3566f8f9172631d88c75fe074b0ce2127963b7265d310df9aeed03a"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "backoff" do
    url "https:files.pythonhosted.orgpackages47d75bbeb12c44d7c4f2fb5b56abce497eb5ed9f34d85701de869acedd602619backoff-2.2.1.tar.gz"
    sha256 "03f829f5bb1923180821643f8753b0502c3b682293992485b0eef2807afa5cba"
  end

  resource "base58" do
    url "https:files.pythonhosted.orgpackages7f458ae61209bb9015f516102fa559a2914178da1d5868428bd86a1b4421141dbase58-2.1.1.tar.gz"
    sha256 "c5d0cb3f5b6e81e8e35da5754388ddcc6d0d14b6c6a132cb93d69ed580a7278c"
  end

  resource "bittensor-wallet" do
    url "https:files.pythonhosted.orgpackages01a1e80b2785821f4acfd37cfff74599cc66752a796f5f92e37b9358970e144fbittensor_wallet-3.0.10.tar.gz"
    sha256 "06af94c589cff82d3ec039c9b2c2829ad048b44410292e710af86a9baa77833e"
  end

  resource "bt-decode" do
    url "https:files.pythonhosted.orgpackages76d4cbbe3201561b1467e53bb5a111d968d3364d58633c58009343db9a5c2915bt_decode-0.6.0.tar.gz"
    sha256 "05e67b5ab018af7a31651bb9c0fb838c3a1733806823019d14c287922869f84e"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  # click > 8.2.0 is unsupported
  # https:github.comopentensorbtcliblobv9.7.0pyproject.toml#L21
  resource "click" do
    url "https:files.pythonhosted.orgpackagesb92e0090cbf739cee7d23781ad4b89a9894a41538e4fcf4c31dcdd705b78eb8bclick-8.1.8.tar.gz"
    sha256 "ed53c9d8990d83c2a27deae68e4ee337473f6330c040a31d4225c9574d16096a"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages79b1b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages729463b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320agitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "GitPython" do
    url "https:files.pythonhosted.orgpackagesc08937df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "Jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "MarkupSafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackagescea0834b0cebabbfc7e311f30b46c8188790a37f89fc8d756660346fe5abfd09more_itertools-10.7.0.tar.gz"
    sha256 "9fddd5403be01a94b204faadcff459ec3568cf110265d3c54323e1e866ad29d3"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages46b559f27b4ce9951a4bce56b88ba5ff5159486797ab18863f2b4c1c5e8465bdmultidict-6.5.0.tar.gz"
    sha256 "942bd8002492ba819426a8d7aefde3189c1b87099cdf18aaaefefcf7f3f7b6d2"
  end

  resource "narwhals" do
    url "https:files.pythonhosted.orgpackages37d9ec1bd9f85d30de741b281ef24dabbf029122b638ea19456ffa1b1d862205narwhals-1.43.0.tar.gz"
    sha256 "5a28119401fccb4d344704f806438a983bb0a5b3f4a638760d25b1d521a18a79"
  end

  resource "netaddr" do
    url "https:files.pythonhosted.orgpackages5490188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229dnetaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "password-strength" do
    url "https:files.pythonhosted.orgpackagesdbf16165ebcca27fca3f1d63f8c3a45805c2ed8568be4d09219a2aa45e792c14password_strength-0.0.3.post2.tar.gz"
    sha256 "bf4df10a58fcd3abfa182367307b4fd7b1cec518121dd83bf80c1c42ba796762"
  end

  resource "plotille" do
    url "https:files.pythonhosted.orgpackages8a733f342572f7f916e387e546cc502d6cad35e7162ba0bcde203669e15aa3afplotille-5.0.0.tar.gz"
    sha256 "99e5ca51a2e4c922ead3a3b0863cc2c6a9a4b3f701944589df10f42ce02ab3dc"
  end

  resource "plotly" do
    url "https:files.pythonhosted.orgpackagesae77431447616eda6a432dc3ce541b3f808ecb8803ea3d4ab2573b67f8eb4208plotly-6.1.2.tar.gz"
    sha256 "4fdaa228926ba3e3a213f4d1713287e69dcad1a7e66cf2025bd7d7026d5014b4"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackagesa61643264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  # `py-bip39-bindings` is manually updated to 0.2.0 to fix build issue
  resource "py-bip39-bindings" do
    url "https:files.pythonhosted.orgpackages0ae188d75d69d08322555e5fc310d3086df7355942c993abbc0cca50adf93ed9py_bip39_bindings-0.2.0.tar.gz"
    sha256 "38eac2c2be53085b8c2a215ebf12abcdaefee07bc8e00d7649b6b27399612b83"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages8ea68452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "Pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "PyYAML" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "scalecodec" do
    url "https:files.pythonhosted.orgpackagesbc7c703893e7a8751318517a3dd8c0c060b2c30ffa33f4ab5dd6a4ed483f7967scalecodec-1.2.11.tar.gz"
    sha256 "99a2cdbfccdcaf22bd86b86da55a730a2855514ad2309faef4a4a93ac6cbeb8d"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages185d3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fcasetuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages44cda040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3bsmmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "toml" do
    url "https:files.pythonhosted.orgpackagesbeba1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3ctoml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackagesc58c7d682431efca5fd290017663ea4588bf6f2c6aad085c7f108c5dbc316e70typer-0.16.0.tar.gz"
    sha256 "af377ffaee1dbe37ae9440cb4e8f11686ea5ce4e9bae01b84ae7c63b87f1dd3b"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "websockets" do
    url "https:files.pythonhosted.orgpackages21e626d09fab466b7ca9c7737474c52be4f76a40301b08362eb2dbc19dcc16c1websockets-15.0.1.tar.gz"
    sha256 "82544de02076bafba038ce055ee6412d68da13ab47f0c60cab827346de828dee"
  end

  resource "wheel" do
    url "https:files.pythonhosted.orgpackages8a982d9906746cdc6a6ef809ae6338005b3f21bb568bea3165cfc6a243fdc25cwheel-0.45.1.tar.gz"
    sha256 "661e1abd9198507b1409a20c02106d9670b2576e916d58f520316666abca6729"
  end

  resource "xxhash" do
    url "https:files.pythonhosted.orgpackages005ed6e5258d69df8b4ed8c83b6664f2b47d30d2dec551a29ad72a6c69eafd31xxhash-3.5.0.tar.gz"
    sha256 "84f2caddf951c9cbf8dc2e22a89d4ccf5d86391ac6418fe81e3c67d0cf60b45f"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages3cfbefaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  def install
    # required to declare scalecodec's version, issue opened at https:github.comJAMdotTechpy-scale-codecissues130
    ENV["TRAVIS_TAG"] = resource("scalecodec").version.to_s
    # `shellingham` auto-detection doesn't work in Homebrew CI build environment so
    # defer installation to allow `typer` to use argument as shell for completions
    # Ref: https:typer.tiangolo.comfeatures#user-friendly-cli-apps
    venv = virtualenv_install_with_resources start_with: ["setuptools", "wheel", "toml"], without: "shellingham"
    generate_completions_from_executable(bin"btcli", "--show-completion")
    venv.pip_install resource("shellingham")
  end

  test do
    require "json"
    wallet_path = testpath"btcli-brew-test"
    test_wallet_name = "brew-test"
    ss58_address = "5FHneW46xGXgs5mUiveU4sbTyGBzmstUspZC92UhjJM694ty"

    # Create wallet
    create_args = %W[
      --wallet-name #{test_wallet_name}
      --wallet-path #{wallet_path}
      --hotkey default
      --no-use-password
      --uri Bob
      --overwrite
      --json-output
    ]
    output = shell_output("#{bin}btcli w create #{create_args.join(" ")}")

    expected_create = {
      "success" => true,
      "error"   => "",
      "data"    =>
                   {
                     "name"         => test_wallet_name,
                     "path"         => wallet_path.to_s,
                     "hotkey"       => "default",
                     "hotkey_ss58"  => ss58_address,
                     "coldkey_ss58" => ss58_address,
                   },
    }

    parsed_create = JSON.parse(output)
    assert_equal expected_create, parsed_create

    # Check balance of the created wallet on the finney network
    balance_args = %W[
      --network finney
      --wallet-path #{wallet_path}
      --wallet-name #{test_wallet_name}
      --json-output
    ]
    balance_output = shell_output("#{bin}btcli w balance #{balance_args.join(" ")}")

    expected_balance = {
      "balances" => {
        "brew-test" => {
          "coldkey"              => ss58_address,
          "free"                 => 0.0,
          "staked"               => 0.0,
          "staked_with_slippage" => 0.0,
          "total"                => 0.0,
          "total_with_slippage"  => 0.0,
        },
      },
      "totals"   => {
        "free"                 => 0.0,
        "staked"               => 0.0,
        "staked_with_slippage" => 0.0,
        "total"                => 0.0,
        "total_with_slippage"  => 0.0,
      },
    }

    parsed_balance = JSON.parse(balance_output)
    assert_equal expected_balance, parsed_balance
  end
end