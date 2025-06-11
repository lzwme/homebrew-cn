class Gptme < Formula
  include Language::Python::Virtualenv

  desc "AI assistant in your terminal"
  homepage "https:gptme.orgdocs"
  url "https:files.pythonhosted.orgpackages5e828d6200fabd2dfaee7ab62713a51174b2634d0ef47cea17a1c67871625c43gptme-0.27.0.tar.gz"
  sha256 "6d2ebc20275d028a6f013a05e9b6a93d7bc02fc39ecb6ec3003d573c0690f11c"
  license "MIT"
  revision 2
  head "https:github.comErikBjaregptme.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7484af5292adb27d27d837a7a0af5b3a6dfbe7af80351a92e4e233e5c46f83fe"
    sha256 cellar: :any,                 arm64_sonoma:  "f9e0b7932cde7f7e1e5f53c7edac2f7e7a242a6607dbd29ca83eef5c085ed647"
    sha256 cellar: :any,                 arm64_ventura: "35817ddbdb8eef12958f5cda311f5bfa6f0e1414134f2805724b7e8f4a994312"
    sha256 cellar: :any,                 sonoma:        "b5ac7fc5aa195fdbc7db675fa257b4a94afb9502a2fd1ecd0dc5c7c08a383b75"
    sha256 cellar: :any,                 ventura:       "38dbb0137bfcc39dfd555bf0b768d83dcc58397e5fa5355770540edbe00e66b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3215bf39eaa9a72c20a707a7011bda7279fc25a34b5b394e8c688ea7cf76f2a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "462059e69ab67f78bb4b64b3fa579343f73b2a40e5e60ba11bd1c30dc18685c0"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "pillow"
  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "annotated-types" do
    url "https:files.pythonhosted.orgpackagesee67531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anthropic" do
    url "https:files.pythonhosted.orgpackages6465175bf024bd9866ef96470620e164dcf8c3e0a2892178e59d1532465c8315anthropic-0.47.2.tar.gz"
    sha256 "452f4ca0c56ffab8b6ce9928bf8470650f88106a7001b250895eb65c54cfa44c"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages957d4c1bd541d4dffa1b52bd83fb8527089e097a106fc90b467a7313b105f840anyio-4.9.0.tar.gz"
    sha256 "673c0c244e15788651a4ff38710fea9675823028a6f08a5eda409e0c9840a028"
  end

  resource "asttokens" do
    url "https:files.pythonhosted.orgpackages4ae782da0a03e7ba5141f05cce0d302e6eed121ae055e0456ca228bf693984bcasttokens-3.0.0.tar.gz"
    sha256 "0dcd8baa8d62b0c1d118b399b2ddba3c4aff271d0d7a9e0d4c1681c79035bbc7"
  end

  resource "bashlex" do
    url "https:files.pythonhosted.orgpackages7660aae0bb54f9af5e0128ba90eb83d8d0d506ee8f0475c4fdda3deeda20b1d2bashlex-0.18.tar.gz"
    sha256 "5bb03a01c6d5676338c36fd1028009c8ad07e7d61d8a1ce3f513b7fff52796ee"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages606c8ca2efa64cf75a977a0d7fac081354553ebe483345c734fb6b6515d96bbcclick-8.2.1.tar.gz"
    sha256 "27c491cc05d968d271d5a1db13e3b5a184636d9d930f148c50b038f0d0646202"
  end

  resource "decorator" do
    url "https:files.pythonhosted.orgpackages43fa6d96a0978d19e17b68d634497769987b16c8f4cd0a7a05048bec693caa6bdecorator-5.2.1.tar.gz"
    sha256 "65f266143752f734b0a7cc83c46f4618af75b8c5911b00ccb61d0ac9b6da0360"
  end

  resource "distro" do
    url "https:files.pythonhosted.orgpackagesfcf898eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "executing" do
    url "https:files.pythonhosted.orgpackages9150a9d80c47ff289c611ff12e63f7c5d13942c65d68125160cefd768c73e6e4executing-2.2.0.tar.gz"
    sha256 "5d108c028108fe2551d1a7b2e8b713341e2cb4fc0aa7dcf966fa4327a5226755"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackages01ee02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages069482699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cbhttpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackagesb1df48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "ipython" do
    url "https:files.pythonhosted.orgpackages853110ac88f3357fc276dc8a64e8880c82e80e7459326ae1d0a211b40abf6665ipython-8.37.0.tar.gz"
    sha256 "ca815841e1a41a1e6b73a0b08f3038af9b2252564d01fc405356d34033012216"
  end

  resource "jedi" do
    url "https:files.pythonhosted.orgpackages723a79a912fbd4d8dd6fbb02bf69afd3bb72cf0c729bb3063c6f4498603db17ajedi-0.19.2.tar.gz"
    sha256 "4770dc3de41bde3966b02eb84fbcf557fb33cce26ad23da12c742fb50ecb11f0"
  end

  resource "jiter" do
    url "https:files.pythonhosted.orgpackagesee9dae7ddb4b8ab3fb1b51faf4deb36cb48a4fbbd7cb36bad6a5fca4741306f7jiter-0.10.0.tar.gz"
    sha256 "07a7142c38aacc85194391108dc91b5b57093c978a9932bd86a36862759d9500"
  end

  resource "json-repair" do
    url "https:files.pythonhosted.orgpackagesed00850d481c0cb290f399610d5b5693f95634780b6a21d04719ab32d772d8bfjson_repair-0.32.0.tar.gz"
    sha256 "eed776fb24dbcce5bcd200f3c254a7d70fda40405c31c97f52a5ca8cfb7cf3e4"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackages763d14e82fc7c8fb1b7761f7e748fd47e2ec8276d137b6acfe5a4bb73853e08flxml-5.4.0.tar.gz"
    sha256 "d12832e1dbea4be280b22fd0ea7c9b87f0d8fc51ba06e92dc62d52f804f78ebd"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "matplotlib-inline" do
    url "https:files.pythonhosted.orgpackages995ba36a337438a14116b16480db471ad061c36c3694df7c2084a0da7ba538b7matplotlib_inline-0.1.7.tar.gz"
    sha256 "8423b23ec666be3d16e16b60bdd8ac4e86e840ebd1dd11a30b9f117f2fa0ab90"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "multiprocessing-logging" do
    url "https:files.pythonhosted.orgpackages9efe32bd864bcb604b0607924a4cf618ed267a0ef21ac9c3e255109256046e1fmultiprocessing_logging-0.3.4-py2.py3-none-any.whl"
    sha256 "8a5be02b02edbd6fa6e3e89499af7680db69db9e2d8707fcd28d445fa248f23e"
  end

  resource "openai" do
    url "https:files.pythonhosted.orgpackagesec7a9ad4a61f1502f0e59d8c27fb629e28a63259a44d8d31cd2314e1534a2d9fopenai-1.86.0.tar.gz"
    sha256 "c64d5b788359a8fdf69bd605ae804ce41c1ce2e78b8dd93e2542e0ee267f1e4b"
  end

  resource "parso" do
    url "https:files.pythonhosted.orgpackages669468e2e17afaa9169cf6412ab0f28623903be73d1b32e208d9e8e541bb086dparso-0.8.4.tar.gz"
    sha256 "eb3a7b58240fb99099a345571deecc0f9540ea5f4dd2fe14c2a99d6b281ab92d"
  end

  resource "pexpect" do
    url "https:files.pythonhosted.orgpackages4292cc564bf6381ff43ce1f4d06852fc19a2f11d180f23dc32d9588bee2f149dpexpect-4.9.0.tar.gz"
    sha256 "ee7d41123f3c9911050ea2c2dac107568dc43b2d3b0c7557a33212c398ead30f"
  end

  resource "pick" do
    url "https:files.pythonhosted.orgpackagesdff5980b90af3fd82d18adaa3a1249037d3b1f95e201d640e17a7c5ce6188f45pick-2.4.0.tar.gz"
    sha256 "71f1b1b5d83652f87652fea5f51a3ba0b3388a71718cdcf8c6bc1326f85ae0b9"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackagesfe8b3c73abc9c759ecd3f1f7ceff6685840859e8070c4d947c93fae71f6a0bf2platformdirs-4.3.8.tar.gz"
    sha256 "3d512d96e16bcb959a814c9f348431070822a6496326a4be0911c40b5a74c2bc"
  end

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesbb6e9d084c929dfe9e3bfe0c6a47e31f78a25c54627d64a66e884a8bf5474f1cprompt_toolkit-3.0.51.tar.gz"
    sha256 "931a162e3b27fc90c86f1b48bb1fb2c528c2761475e57c9c06de13311c7b54ed"
  end

  resource "ptyprocess" do
    url "https:files.pythonhosted.orgpackages20e516ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4eptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https:files.pythonhosted.orgpackagescd050a34433a064256a578f1783a10da6df098ceaa4a57bbeaa96a6c0352786bpure_eval-0.2.3.tar.gz"
    sha256 "5f4e983f40564c576c7c8635ae88db5956bb2229d7e9237d03b3c0b0190eaf42"
  end

  resource "pydantic" do
    url "https:files.pythonhosted.orgpackagesf0868ce9040065e8f924d642c58e4a344e33163a07f6b57f836d0d734e0ad3fbpydantic-2.11.5.tar.gz"
    sha256 "7f853db3d0ce78ce8bbb148c401c2cdd6431b3473c0cdff2755c7690952a7b7a"
  end

  resource "pydantic-core" do
    url "https:files.pythonhosted.orgpackagesad885f2260bdfae97aabf98f1778d43f69574390ad787afb646292a638c923d4pydantic_core-2.33.2.tar.gz"
    sha256 "7cb8bc3605c29176e1b105350d2e6474142d7c1bd1d9327c4a9bdb46bf827acc"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackages882c7bb1416c5620485aa793f2de31d3df393d3686aa8a8506d11e10e13c5bafpython_dotenv-1.1.0.tar.gz"
    sha256 "41f90bc6f5f177fb41f53e87666db362025010eb28f60a01c9143bfa33a2b2d5"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages8e5fbd69653fbfb76cf8604468d3b4ec4c403197144c7bfe0e6a5fc9e02a07cbregex-2024.11.6.tar.gz"
    sha256 "7ab159b063c52a0333c884e4679f8d7a85112ee3078fe3d9004b2dd875585519"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesab3a0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bcrich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "stack-data" do
    url "https:files.pythonhosted.orgpackages28e355dcc2cfbc3ca9c29519eb6884dd1415ecb53b0e934862d3559ddcb7e20bstack_data-0.6.3.tar.gz"
    sha256 "836a778de4fec4dcd1dcd89ed8abff8a221f58308462e1c4aa2a3cf30148f0b9"
  end

  resource "tabulate" do
    url "https:files.pythonhosted.orgpackagesecfe802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tiktoken" do
    url "https:files.pythonhosted.orgpackageseacf756fedf6981e82897f2d570dd25fa597eb3f4459068ae0572d7e888cfd6ftiktoken-0.9.0.tar.gz"
    sha256 "d02a5ca6a938e0490e1ff957bc48c8b078c88cb83977be1625b1fd8aac792c5d"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagescc180bbf3884e9eaa38819ebe46a7bd25dcd56b67434402b66a58c4b8e552575tomlkit-0.13.3.tar.gz"
    sha256 "430cf247ee57df2b94ee3fbe588e71d362a941ebb545dec29b53961d61add2a1"
  end

  resource "tqdm" do
    url "https:files.pythonhosted.orgpackagesa84b29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744dtqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "traitlets" do
    url "https:files.pythonhosted.orgpackageseb7972064e6a701c2183016abbbfedaba506d81e30e232a68c9f0d6f6fcd1574traitlets-5.14.3.tar.gz"
    sha256 "9ed0579d3502c94b4b3732ac120375cda96f923114522847de4b3bb98b96b6b7"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesd1bc51647cd02527e87d05cb083ccc402f93e441606ff1f01739a62c8ad09ba5typing_extensions-4.14.0.tar.gz"
    sha256 "8676b788e32f02ab42d9e7c61324048ae4c6d844a399eebace3d4979d75ceef4"
  end

  resource "typing-inspection" do
    url "https:files.pythonhosted.orgpackagesf8b10c11f5058406b3af7609f121aaa6b609744687f1d158b3c3a5bf4cc94238typing_inspection-0.4.1.tar.gz"
    sha256 "6ae134cc0203c33377d43188d4064e9b357dba58cff3185f22924610e70a9d28"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    # The source doesn't have a valid SOURCE_DATE_EPOCH, so here we set default.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"

    virtualenv_install_with_resources

    generate_completions_from_executable(bin"gptme", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    ENV["OPENAI_API_KEY"] = "brew"

    assert_match version.to_s, shell_output("#{bin}gptme --version")

    assert_match "Found OpenAI API key, using OpenAI provider",
      shell_output("#{bin}gptme -n 2>&1")
  end
end