class Rawdog < Formula
  include Language::Python::Virtualenv

  desc "CLI tool to generate and run code with llms"
  homepage "https://mentat.ai"
  url "https://files.pythonhosted.org/packages/3c/ab/eaae3e0f2fac4a717d632990795fd6a560efaf9e54a1741e842234dec1cb/rawdog_ai-0.1.6.tar.gz"
  sha256 "1fc37d0e3336e87568ae9ee5dde5e7c68c1af652efd0956ee0c62281ddf14b41"
  license "Apache-2.0"
  revision 15
  head "https://github.com/AbanteAI/rawdog.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_tahoe:   "9cbb7c73d516ad3a78db3f1f40798c9b7883ad225baac1216df2c870d112d783"
    sha256 cellar: :any,                 arm64_sequoia: "c4ecee0d66a983345fb065a8051177fdbf59c7e0329f8f31e041acd60f7e8916"
    sha256 cellar: :any,                 arm64_sonoma:  "46e643f7cbec4347a10ac94baf1824c95f51840b62afa90fa52b794ee1b42e19"
    sha256 cellar: :any,                 sonoma:        "1835c27b0f277885ffe22b1659b23df12046e93f5ca4ec85367165b85419be20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "703cba17c970e03198ecbe6539676c1eac336725919820c630d5f9201062f7c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25f52160771ed0076464099a98538fbbbd4d23bbe1b1a561d1f022e4bd381ead"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "libyaml"
  depends_on "python@3.14"

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/62/f1/8515650ac3121a9e55c7b217c60e7fae3e0134b5acfe65691781b5356929/aiohttp-3.13.0.tar.gz"
    sha256 "378dbc57dd8cf341ce243f13fa1fa5394d68e2e02c15cd5f28eae35a70ec7f67"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/83/2d/5fd176ceb9b2fc619e63405525573493ca23441330fcdaee6bef9460e924/charset_normalizer-3.4.3.tar.gz"
    sha256 "6fce4b8500244f6fcb71465d4a4930d132ba9ab8e71a7859e6a5d59851068d14"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "fastuuid" do
    url "https://files.pythonhosted.org/packages/15/80/3c16a1edad2e6cd82fbd15ac998cc1b881f478bf1f80ca717d941c441874/fastuuid-0.13.5.tar.gz"
    sha256 "d4976821ab424d41542e1ea39bc828a9d454c3f8a04067c06fca123c5b95a1a1"

    # Fix to build with Python 3.14
    # PR ref: https://github.com/fastuuid/fastuuid/pull/59
    patch do
      url "https://github.com/fastuuid/fastuuid/commit/2ec12beccb8ab6bb000251731ee9c2f89c459dfe.patch?full_index=1"
      sha256 "325b6f157e3aa2e7ccba564d4abff1300754724fa45e18883f38a769b6c33c13"
    end
    patch do
      url "https://github.com/fastuuid/fastuuid/commit/bed5060596a6d63766bb4f2a73c8b3cef55f1fe5.patch?full_index=1"
      sha256 "a42285417f4cb35de6ceb6f3fb683044c9fb86f1e275a98130cb19994a5c6968"
    end
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/58/46/0028a82567109b5ef6e4d2a1f04a583fb513e6cf9527fcdd09afd817deeb/filelock-3.20.0.tar.gz"
    sha256 "711e943b4ec6be42e1d4e6690b48dc175c822967466bb31c0c293f34334c13f4"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/de/e0/bab50af11c2d75c9c4a2a26a5254573c0bd97cea152254401510950486fa/fsspec-2025.9.0.tar.gz"
    sha256 "19fd429483d25d28b65ec68f9f4adc16c17ea2c7c7bf54ec61360d478fb19c19"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/74/31/feeddfce1748c4a233ec1aa5b7396161c07ae1aa9b7bdbc9a72c3c7dd768/hf_xet-1.1.10.tar.gz"
    sha256 "408aef343800a2102374a883f283ff29068055c111f003ff840733d3b715bb97"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/10/7e/a0a97de7c73671863ca6b3f61fa12518caf35db37825e43d63a70956738c/huggingface_hub-0.35.3.tar.gz"
    sha256 "350932eaa5cc6a4747efae85126ee220e4ef1b54e29d31c3b45c5612ddf0b32a"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/76/66/650a33bd90f786193e4de4b3ad86ea60b53c89b669a5c7be931fac31cdb0/importlib_metadata-8.7.0.tar.gz"
    sha256 "d13b81ad223b890aa16c5471f2ac3056cf76c5f10f82d6f9292f0b415f389000"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/df/bf/f7da0350254c0ed7c72f3e33cef02e048281fec7ecec5f032d4aac52226b/jinja2-3.1.6.tar.gz"
    sha256 "0137fb05990d35f1275a587e9aee6d56da821fc83491a0fb838183be43f66d6d"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/9d/c0/a3bb4cc13aced219dd18191ea66e874266bd8aa7b96744e495e1c733aa2d/jiter-0.11.0.tar.gz"
    sha256 "1d9637eaf8c1d6a63d6562f2a6e5ab3af946c66037eb1b894e8fad75422266e4"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "litellm" do
    url "https://files.pythonhosted.org/packages/fd/3e/1a96a3caeeb6092d85e70904e2caa98598abb7179cefe734e2fbffac6978/litellm-1.78.0.tar.gz"
    sha256 "020e40e0d6e16009bb3a6b156d4c1d98cb5c33704aa340fdf9ffd014bfd31f3b"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/7e/99/7690b6d4034fffd95959cbe0c02de8deb3098cc577c67bb6a24fe5d7caa7/markupsafe-3.0.3.tar.gz"
    sha256 "722695808f4b6457b320fdc131280796bdceb04ab50fe1795cd540799ebe1698"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/80/1e/5492c365f222f907de1039b91f922b93fa4f764c713ee858d235495d8f50/multidict-6.7.0.tar.gz"
    sha256 "c6e99d9a65ca282e578dfea819cfa9c0a62b2499d8677392e09feaf305e9e6f5"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/de/90/8f26554d24d63ed4f94d33c24271559863223a67e624f4d2e65ba8e48dca/openai-2.3.0.tar.gz"
    sha256 "8d213ee5aaf91737faea2d7fc1cd608657a5367a18966372a3756ceaabfbd812"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/a1/d4/1fc4078c65507b51b96ca8f8c3ba19e6a61c8253c72794544580a7b6c24d/packaging-25.0.tar.gz"
    sha256 "d443872c98d677bf60f6a1f2f8c1cb748e8fe762d2bf9d3148b5599295b0fc4f"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/c3/da/b8a7ee04378a53f6fefefc0c5e05570a3ebfdfa0523a878bcd3b475683ee/pydantic-2.12.0.tar.gz"
    sha256 "c1a077e6270dbfb37bfd8b498b3981e2bb18f68103720e51fa6c306a5a9af563"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/7d/14/12b4a0d2b0b10d8e1d9a24ad94e7bbb43335eaf29c0c4e57860e8a30734a/pydantic_core-2.41.1.tar.gz"
    sha256 "1ad375859a6d8c356b7704ec0f547a58e82ee80bb41baa811ad710e124bc8f2f"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/f6/b0/4bc07ccd3572a2f9df7e6782f52b0c6c90dcbb803ac4a167702d7d0dfe1e/python_dotenv-1.1.1.tar.gz"
    sha256 "a8a6399716257f45be6a007360200409fce5cda2661e3dec71d23dc15f6189ab"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/2f/db/98b5c277be99dd18bfd91dd04e1b759cad18d1a338188c936e92f921c7e2/referencing-0.36.2.tar.gz"
    sha256 "df2e89862cd09deabbdba16944cc3f10feb6b3e6f18e902f7cc25609a34775aa"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/49/d3/eaa0d28aba6ad1827ad1e716d9a93e1ba963ada61887498297d3da715133/regex-2025.9.18.tar.gz"
    sha256 "c5ba23274c61c6fef447ba6a39333297d0c247f53059dba0bca415cac511edc4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e9/dd/2c0cbe774744272b0ae725f44032c77bdcab6e8bcf544bffa3b6e70c8dba/rpds_py-0.27.1.tar.gz"
    sha256 "26a1c73171d10b7acccbded82bf6a586ab8203601e565badc74bbbf8bc5a10f8"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/7d/ab/4d017d0f76ec3171d469d80fc03dfbb4e48a4bcaddaa831b31d526f05edc/tiktoken-0.12.0.tar.gz"
    sha256 "b18ba7ee2b093863978fcb14f74b3707cdc8d4d4d3836853ce7ec60772139931"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/1c/46/fb6854cec3278fbfa4a75b50232c77622bc517ac886156e6afbfa4d8fc6e/tokenizers-0.22.1.tar.gz"
    sha256 "61de6522785310a309b3407bac22d99c4db5dba349935e99e4d15ea2226af2d9"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/e3/02/0f2892c661036d50ede074e376733dca2ae7c6eb617489437771209d4180/zipp-3.23.0.tar.gz"
    sha256 "a07157588a12518c9d4034df3fbbee09c814741a33ff63c05fa29d26a2404166"
  end

  def install
    venv = virtualenv_install_with_resources(without: "hf-xet")

    resource("hf-xet").stage do
      if ENV.effective_arch == :armv8
        # Disable sha2-asm which requires a minimum of -march=armv8-a+crypto
        inreplace "data/Cargo.toml",
                  'sha2 = { workspace = true, features = ["asm"] }',
                  "sha2 = { workspace = true }"
      end
      venv.pip_install Pathname.pwd
    end
  end

  test do
    output = shell_output("#{bin}/rawdog test prompt 2>&1", 1)
    assert_match "The api_key client option must be set", output
  end
end