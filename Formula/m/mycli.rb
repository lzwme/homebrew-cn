class Mycli < Formula
  include Language::Python::Virtualenv

  desc "CLI for MySQL with auto-completion and syntax highlighting"
  homepage "https://www.mycli.net/"
  url "https://files.pythonhosted.org/packages/62/63/0686c6336f9797da19d2a3d58befeec4fb62991f9b8a8cfdd2ab646e0e36/mycli-1.41.0.tar.gz"
  sha256 "d919d7c3a53257cb8db67d50d7ce51e97c36201c923e923d82f55f32d4bf1d5a"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bcf38978846d7e70bd3d00228d8a4aaa157e4867aafb2824b690c07aac704840"
    sha256 cellar: :any,                 arm64_sequoia: "ede3e5fcf51b875fc7cdc7ade22e374a1fecca944d9bd76099aceb74d16391db"
    sha256 cellar: :any,                 arm64_sonoma:  "ecf1c3aa181abc74f41709f58491f86adb1b4edd2dc09841cf8e9265de2ca44d"
    sha256 cellar: :any,                 sonoma:        "2810cc48ea4c7b63cbea2d6c0ef919e5197e45d760ab1b0b1194c06383efb84e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d439d6d2fd0092035281507934deff130b40b72f954fe99929093611255cfb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "64a24a288b15ceb9136a92563f0cd8a10e23090aa250799d63b5067e1eb62880"
  end

  depends_on "rust" => :build # for jiter, sqlglotrs
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pydantic-core" => :no_linkage
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages package_name:     "mycli[llm]",
                exclude_packages: %w[certifi cryptography pydantic-core]

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "cli-helpers" do
    url "https://files.pythonhosted.org/packages/5a/e6/51b043e8c4ae390af61af35f73a9c2a69a26ea9cf4d061ab45c59f8e20f4/cli_helpers-2.7.0.tar.gz"
    sha256 "62d11710dbebc2fc460003de1215688325d8636859056d688b38419bd4048bc0"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https://files.pythonhosted.org/packages/1d/ce/edb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41df/click_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "condense-json" do
    url "https://files.pythonhosted.org/packages/94/b3/d784cbc05556192ea1e798cae96363835d649fe7420ff030190789645be1/condense_json-0.1.3.tar.gz"
    sha256 "25fe8d434fdafd849e8d98f21a3e18f96ae2d6dbc2c17565f29e4843d039d2bc"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/f5/c4/c7f9e41bc2e5f8eeae4a08a01c91b2aea3dfab40a3e14b25e87e7db8d501/configobj-5.0.9.tar.gz"
    sha256 "03c881bbf23aa07bccf1b837005975993c4ab4427ba57f959afdd9d1a2386848"
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
    url "https://files.pythonhosted.org/packages/a3/68/0357982493a7b20925aece061f7fb7a2678e3b232f8d73a6edb7e5304443/jiter-0.11.1.tar.gz"
    sha256 "849dcfc76481c0ea0099391235b7ca97d7279e0fa4c86005457ac7c88e8b76dc"
  end

  resource "llm" do
    url "https://files.pythonhosted.org/packages/05/7f/f2fe103b8fa6c5a96ba117fef46af15c766d4c28640893c2c7feb79c0df3/llm-0.27.1.tar.gz"
    sha256 "02b0b393e31cf0e0ee1f2a6006c451c74ec18c7ec3973218de56e76fd72baa80"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/c4/44/303deb97be7c1c9b53118b52825cbd1557aeeff510f3a52566b1fa66f6a2/openai-2.6.1.tar.gz"
    sha256 "27ae704d190615fca0c0fc2b796a38f8b5879645a3a52c9c453b23f97141bb49"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/f9/e2/3e91f31a7d2b083fe6ef3fa267035b518369d9511ffab804f839851d2779/pluggy-1.6.0.tar.gz"
    sha256 "7dcc130b76258d33b90f61b658791dede3486c3e6bfb003ee5c9bfb396dd22f3"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/a1/96/06e01a7b38dce6fe1db213e061a4602dd6032a8a97ef6c1a862537732421/prompt_toolkit-3.0.52.tar.gz"
    sha256 "28cde192929c8e7321de85de1ddbe736f1375148b02f2e17edd840042b1be855"
  end

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/dd/7f/9998706bc516bdd664ccf929a1da6c6e5ee06e48f723ce45aae7cf3ff36e/puremagic-1.30.tar.gz"
    sha256 "f9ff7ac157d54e9cf3bff1addfd97233548e75e685282d84ae11e7ffee1614c9"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/c9/85/e24bf90972a30b0fcd16c73009add1d7d7cd9140c2498a68252028899e41/pycryptodomex-3.23.0.tar.gz"
    sha256 "71909758f010c82bc99b0abf4ea12012c98962fbf0583c2164f8b84533c2e4da"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/f3/1e/4f0a3233767010308f2fd6bd0814597e3f63f1dc98304a9112b8759df4ff/pydantic-2.12.3.tar.gz"
    sha256 "1da1c82b0fc140bb0103bc1441ffe062154c8d38491189751ee00fd8ca65ce74"
  end

  resource "pyfzf" do
    url "https://files.pythonhosted.org/packages/d4/4c/c0c658a1e1e9f0e01932990d7947579515fe048d0a515f07458ecd992b8f/pyfzf-0.3.1.tar.gz"
    sha256 "dd902e34cffeca9c3082f96131593dd20b4b3a9bba5b9dde1b0688e424b46bd2"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pymysql" do
    url "https://files.pythonhosted.org/packages/f5/ae/1fe3fcd9f959efa0ebe200b8de88b5a5ce3e767e38c7ac32fb179f16a388/pymysql-1.1.2.tar.gz"
    sha256 "4961d3e165614ae65014e361811a724e2044ad3ea3739de9903ae7c21f539f03"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/e8/52/d87eba7cb129b81563019d1679026e7a112ef76855d6159d24754dbd2a51/pyperclip-1.11.0.tar.gz"
    sha256 "244035963e4428530d9e3a6101a1ef97209c6825edab1567beac148ccc1db1b6"
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

  resource "sqlglot" do
    url "https://files.pythonhosted.org/packages/d1/50/766692a83468adb1bde9e09ea524a01719912f6bc4fdb47ec18368320f6e/sqlglot-27.29.0.tar.gz"
    sha256 "2270899694663acef94fa93497971837e6fadd712f4a98b32aee1e980bc82722"
  end

  resource "sqlglotrs" do
    url "https://files.pythonhosted.org/packages/87/5a/46d8efeda45be6ce1c630229455f000cafedea6129b47e6cfab39ff462f5/sqlglotrs-0.7.3.tar.gz"
    sha256 "caadc572c8a194f99d6ba44d02f9ada0110e3d47cca3330c81f4aa608f1143eb"
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

  resource "sqlparse" do
    url "https://files.pythonhosted.org/packages/e5/40/edede8dd6977b0d3da179a342c198ed100dd2aba4be081861ee5911e4da4/sqlparse-0.5.3.tar.gz"
    sha256 "09f67787f56a0b16ecdbde1bfc7f5d9c3371ca683cfeaa8e6ff60b4807ec9272"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/a8/4b/29b4ef32e036bb34e4ab51796dd745cdba7ed47ad142a9f4a1eb8e0c744d/tqdm-4.67.1.tar.gz"
    sha256 "f8aef9c52c08c13a65f30ea34f4e5aac3fd1a34959879d7e59e63027286627f2"
  end

  resource "typing-inspection" do
    url "https://files.pythonhosted.org/packages/55/e3/70399cb7dd41c10ac53367ae42139cf4b1ca5f36bb3dc6c9d33acdb43655/typing_inspection-0.4.2.tar.gz"
    sha256 "ba561c48a67c5958007083d386c3295464928b01faa735ab8547c5692e87f464"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/24/30/6b0809f4510673dc723187aeaf24c7f5459922d01e2f794277a3dfb90345/wcwidth-0.2.14.tar.gz"
    sha256 "4d478375d31bc5395a3c55c40ccdf3354688364cd61c4f6adacaa9215d0b3605"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"mycli", shell_parameter_format: :click)
  end

  test do
    system bin/"mycli", "--help"
  end
end