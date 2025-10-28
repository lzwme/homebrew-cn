class Llm < Formula
  include Language::Python::Virtualenv

  desc "Access large language models from the command-line"
  homepage "https://llm.datasette.io/"
  url "https://files.pythonhosted.org/packages/05/7f/f2fe103b8fa6c5a96ba117fef46af15c766d4c28640893c2c7feb79c0df3/llm-0.27.1.tar.gz"
  sha256 "02b0b393e31cf0e0ee1f2a6006c451c74ec18c7ec3973218de56e76fd72baa80"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "7faf437a580e0b0d2e047b819e869d09aa2b36000dca6d0cf17ba770c030099d"
    sha256 cellar: :any,                 arm64_sequoia: "2bf6065be3014845801d070227a43ca72289af34474118a44fe07da7a96b850d"
    sha256 cellar: :any,                 arm64_sonoma:  "7b8f1d4d311b0e6738cfd3cae97d3744f5b820c734bcfe89a4bf1ddc5471d7ef"
    sha256 cellar: :any,                 sonoma:        "18dfe453b2edf06f8df59cb65387d428a7df17d557a7b63e4f85a3cddc8afcdb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a072538aaeff6101e8ee6c65b9c1b3cdb2b9df60812bed55427dcf733c765c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b54670d54564c9057475ba987afeb4d879dafd317f103d7b55d6023e307805d"
  end

  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "certifi"

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "condense-json" do
    url "https://files.pythonhosted.org/packages/94/b3/d784cbc05556192ea1e798cae96363835d649fe7420ff030190789645be1/condense_json-0.1.3.tar.gz"
    sha256 "25fe8d434fdafd849e8d98f21a3e18f96ae2d6dbc2c17565f29e4843d039d2bc"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/9d/c0/a3bb4cc13aced219dd18191ea66e874266bd8aa7b96744e495e1c733aa2d/jiter-0.11.0.tar.gz"
    sha256 "1d9637eaf8c1d6a63d6562f2a6e5ab3af946c66037eb1b894e8fad75422266e4"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/de/90/8f26554d24d63ed4f94d33c24271559863223a67e624f4d2e65ba8e48dca/openai-2.3.0.tar.gz"
    sha256 "8d213ee5aaf91737faea2d7fc1cd608657a5367a18966372a3756ceaabfbd812"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dd/7f/9998706bc516bdd664ccf929a1da6c6e5ee06e48f723ce45aae7cf3ff36e/puremagic-1.30.tar.gz"
    sha256 "f9ff7ac157d54e9cf3bff1addfd97233548e75e685282d84ae11e7ffee1614c9"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/8d/35/d319ed522433215526689bad428a94058b6dd12190ce7ddd78618ac14b28/pydantic-2.12.2.tar.gz"
    sha256 "7b8fa15b831a4bbde9d5b84028641ac3080a4ca2cbd4a621a661687e741624fd"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/df/18/d0944e8eaaa3efd0a91b0f1fc537d3be55ad35091b6a87638211ba691964/pydantic_core-2.41.4.tar.gz"
    sha256 "70e47929a9d4a1905a67e4b687d5946026390568a8e952b92824118063cee4d5"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-ulid" do
    url "https://files.pythonhosted.org/packages/40/7e/0d6c82b5ccc71e7c833aed43d9e8468e1f2ff0be1b3f657a6fcafbb8433d/python_ulid-3.1.0.tar.gz"
    sha256 "ff0410a598bc5f6b01b602851a3296ede6f91389f913a5d5f8c496003836f636"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/18/5d/3bf57dcd21979b887f014ea83c24ae194cfcd12b9e0fda66b957c69d1fca/setuptools-80.9.0.tar.gz"
    sha256 "f36b47402ecde768dbfafc46e8e4207b4360c654f1f3bb84475f0a28628fb19c"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "sqlite-fts4" do
    url "https://files.pythonhosted.org/packages/c2/6d/9dad6c3b433ab8912ace969c66abd595f8e0a2ccccdb73602b1291dbda29/sqlite-fts4-1.0.3.tar.gz"
    sha256 "78b05eeaf6680e9dbed8986bde011e9c086a06cb0c931b3cf7da94c214e8930c"
  end

  resource "sqlite-migrate" do
    url "https://files.pythonhosted.org/packages/13/86/1463a00d3c4bdb707c0ed4077d17687465a0aa9444593f66f6c4b49e39b5/sqlite-migrate-0.1b0.tar.gz"
    sha256 "8d502b3ca4b9c45e56012bd35c03d23235f0823c976d4ce940cbb40e33087ded"
  end

  resource "sqlite-utils" do
    url "https://files.pythonhosted.org/packages/51/43/ce9183a21911e0b73248c8fb83f8b8038515cb80053912c2a009e9765564/sqlite_utils-3.38.tar.gz"
    sha256 "1ae77b931384052205a15478d429464f6c67a3ac3b4eafd3c674ac900f623aab"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
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

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"llm", shell_parameter_format: :click)
  end

  test do
    ENV["OPENAI_API_BASE"] = "https://openai-canned-completion.vercel.app/v1"
    ENV["OPENAI_API_KEY"] = "x"
    assert_match "Incorrect API key provided", shell_output("#{bin}/llm hello --no-log 2>&1", 1)

    assert_match "llm, version", shell_output("#{bin}/llm --version")
  end
end