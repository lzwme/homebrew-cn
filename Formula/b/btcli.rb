class Btcli < Formula
  include Language::Python::Virtualenv

  desc "Bittensor command-line tool"
  homepage "https:docs.bittensor.combtcli"
  url "https:files.pythonhosted.orgpackages3a7af8d889187a4883f2fc01a2df512697d488f01576bc74a3aa93c9263d3fa6bittensor_cli-9.7.1.tar.gz"
  sha256 "ccc46ce40ad1cd4766e6287cd3fd407a577be229e87f637b1f0def1c91834c3a"
  license "MIT"
  head "https:github.comopentensorbtcli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "422859540aaa8bba5d2df99b9386df6b746ad8d00eecdf97a7f32186147a3e89"
    sha256 cellar: :any,                 arm64_sonoma:  "0a922e1847a71626fae2d23c3f7b0b245bf3eeb0d32df6cd130c28d75ec8847b"
    sha256 cellar: :any,                 arm64_ventura: "813f54b20b49503f2a2ad3aec600aed59b7df0017ed7376cf4db9ff627809e38"
    sha256 cellar: :any,                 sonoma:        "1a71d1ffe8d95d5018a4d74d71d2244a9d1fe4dc910ef7c7901727c0a56eb025"
    sha256 cellar: :any,                 ventura:       "b9ab2384a099691a78d20ebedda4151166b54bbb7c2fba78e393005320db8d53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e437e00ca1aef726f9a03abff6c78ffe7329b90f0253bc288aa65c03cd708b07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dbbd2b58835d173f7a058572f50720b0f1371384afb38f4d06ef0097f4a8ff1"
  end

  depends_on "rust" => :build # for bittensor-wallet

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "numpy"
  depends_on "openssl@3"
  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages25a88e2ba36c6e3278d62e0c88aa42bb92ddbef092ac363b390dab4421da5cf5aiohttp-3.10.11.tar.gz"
    sha256 "9dc2b8f3dcab2e39e0fa309c8da50c3b55e6f34ab25f1a71d3288f24924d33a7"
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
    url "https:files.pythonhosted.orgpackagesf1b3cdc806f6fbe65f7323af51b4d1f2aaab119f13b0e069e29327a51fd7235ebittensor_wallet-3.0.11.tar.gz"
    sha256 "7c371cc35b53fd5a73add56a1d0fa2f9e2d3203d0936b1f8171cc7907556113a"
  end

  resource "bt-decode" do
    url "https:files.pythonhosted.orgpackages76d4cbbe3201561b1467e53bb5a111d968d3364d58633c58009343db9a5c2915bt_decode-0.6.0.tar.gz"
    sha256 "05e67b5ab018af7a31651bb9c0fb838c3a1733806823019d14c287922869f84e"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

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

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackagesc08937df0b71473153574a5cdef8f242de422a0f5d26d7a9e231e6f169b4ad14gitpython-3.1.44.tar.gz"
    sha256 "c87e30b26253bf5418b01b0660f818967f3c503193838337fe5e573331249269"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesdfbff7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226bjinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "markupsafe" do
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
    url "https:files.pythonhosted.orgpackagesaa6d84d6dbf9a855c09504bdffd4a2c82c6b82cc7b4d69101b64491873967d88multidict-6.6.0.tar.gz"
    sha256 "460b213769cb8691b5ba2f12e53522acd95eb5b2602497d4d7e64069a61e5941"
  end

  resource "narwhals" do
    url "https:files.pythonhosted.orgpackages56e50b875d29e2a4d112c58fef6aac2ed3a73bbdd4d8d0dce722fd154357248anarwhals-1.44.0.tar.gz"
    sha256 "8cf0616d4f6f21225b3b56fcde96ccab6d05023561a0f162402aa9b8c33ad31d"
  end

  resource "netaddr" do
    url "https:files.pythonhosted.orgpackages5490188b2a69654f27b221fba92fda7217778208532c962509e959a9cee5229dnetaddr-1.3.0.tar.gz"
    sha256 "5c3c3d9895b551b763779ba7db7a03487dc1f8e3b385af819af341ae9ef6e48a"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesa1d41fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24dpackaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "plotille" do
    url "https:files.pythonhosted.orgpackages8a733f342572f7f916e387e546cc502d6cad35e7162ba0bcde203669e15aa3afplotille-5.0.0.tar.gz"
    sha256 "99e5ca51a2e4c922ead3a3b0863cc2c6a9a4b3f701944589df10f42ce02ab3dc"
  end

  resource "plotly" do
    url "https:files.pythonhosted.orgpackages6e5c0efc297df362b88b74957a230af61cd6929f531f72f48063e8408702ffbaplotly-6.2.0.tar.gz"
    sha256 "9dfa23c328000f16c928beb68927444c1ab9eae837d1fe648dbcda5360c7953d"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackagesa61643264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "pycryptodome" do
    url "https:files.pythonhosted.orgpackages8ea68452177684d5e906854776276ddd34eca30d1b1e15aa1ee9cefc289a33f5pycryptodome-3.23.0.tar.gz"
    sha256 "447700a657182d60338bab09fdb27518f8856aecd80ae4c6bdddb67ff5da44ef"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackagesb077a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pyyaml" do
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

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages44cda040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3bsmmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "toml" do
    url "https:files.pythonhosted.orgpackagesb9195cbd78eac8b1783671c40e34bb0fa83133a06d340a38b55c645076d40094toml-0.10.0.tar.gz"
    sha256 "229f81c57791a41d65e399fc06bf0848bab550a9dfd5ed66df18ce5f05e73d5c"
  end

  resource "typer" do
    url "https:files.pythonhosted.orgpackages6c89c527e6c848739be8ceb5c44eb8208c52ea3515c6cf6406aa61932887bf58typer-0.15.4.tar.gz"
    sha256 "89507b104f9b6a0730354f27c39fae5b63ccd0c95b1ce1f1a6ba0cfd329997c3"
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
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"
    # required to declare scalecodec's version, issue opened at https:github.comJAMdotTechpy-scale-codecissues130
    ENV["TRAVIS_TAG"] = resource("scalecodec").version.to_s
    virtualenv_install_with_resources

    # `shellingham` auto-detection doesn't work in Homebrew CI build environment so
    # disable it to allow `typer` to use argument as shell for completions
    # Ref: https:typer.tiangolo.comfeatures#user-friendly-cli-apps
    ENV["_TYPER_COMPLETE_TEST_DISABLE_SHELL_DETECTION"] = "1"
    generate_completions_from_executable(bin"btcli", "--show-completion")
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