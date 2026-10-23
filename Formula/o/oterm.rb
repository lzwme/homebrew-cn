class Oterm < Formula
  include Language::Python::Virtualenv

  desc "Terminal client for Ollama"
  homepage "https://github.com/ggozad/oterm"
  url "https://files.pythonhosted.org/packages/0f/67/ddde964be663cb5f9c0bc7c6bc34d19749d220cb099be4dd460184b052a4/oterm-0.26.1.tar.gz"
  sha256 "b60a9ad8856aaf60fa7f9cba3be7707f7cc1886a7530a143b86df7095ba74257"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ff469604b495ea1f95799ba5ccbe0569546ae77b1609b51c80f24c87c5b5bd65"
    sha256 cellar: :any, arm64_tahoe:       "22f6b9c8fab8764a7a4f8657eb1b5a303b0756ac3de22b32ef0cd76f39cdb7c9"
    sha256 cellar: :any, arm64_sequoia:     "a8d9d8a5e37e7a3e5f4ac621c5d1017736ddee42ca3bd41b199fb702325c5501"
    sha256 cellar: :any, arm64_linux:       "6f7407657214e9b8594253d644ef2e878f8b33ca4356fdc81cb85832ea35af82"
    sha256 cellar: :any, x86_64_linux:      "2eb2c17f55b815626935d30a1fde3801fa9033ab708f71103150104cdf5d3b4e"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build # for textual_speedups
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libyaml"
  depends_on "pillow" => :no_linkage
  depends_on "pydantic" => :no_linkage
  depends_on "python@3.15"
  depends_on "rpds-py" => :no_linkage

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  on_linux do
    depends_on "openssl@4"
    depends_on "zlib-ng-compat"
  end

  pypi_packages exclude_packages: %w[certifi cryptography pillow pydantic rpds-py],
                extra_packages:   %w[jeepney secretstorage]

  resource "aiofile" do
    url "https://files.pythonhosted.org/packages/14/31/edb06aabd8f8f0b56d659f30800795f40b93cba96be946ce179f6931e3a5/aiofile-3.12.3.tar.gz"
    sha256 "caa6aa746b5e47e2165f7abd741b6415e49cf4d44fddc0f61844612cc3924d41"
  end

  resource "aiosql" do
    url "https://files.pythonhosted.org/packages/dc/31/97ebbd15ead5cf9c3951d6e8dfafc5e7b7e8c52148768cb7b95cd443fc8a/aiosql-15.0.tar.gz"
    sha256 "744939fdfb3e0c36d88ccaf1f73cb1cf8cc38e7052666b884502db99aff8f3fd"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/4e/8a/64761f4005f17809769d23e518d915db74e6310474e733e3593cfc854ef1/aiosqlite-0.22.1.tar.gz"
    sha256 "043e0bd78d32888c0a9ca90fc788b38796843360c855a7262a532813133a0650"
  end

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anthropic" do
    url "https://files.pythonhosted.org/packages/4e/66/4ec271f7607460005276bb09b0d1c749a9ed0cead35a488a8676f15ed6d5/anthropic-1.17.0.tar.gz"
    sha256 "dcf77a74dde89a9fd12405fca798b012725a107f7c9488454234a74e275c2163"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/c9/dc/087c08741a98d234c9b98beef8a28d3c309f814d14b6156422c5815bf6d6/authlib-1.9.1.tar.gz"
    sha256 "5c7d9848f47cac340f060f76ae0bc09b59f5c8e89cc1bb032d4370a0c55b5974"
  end

  resource "beartype" do
    url "https://files.pythonhosted.org/packages/79/34/c0cfdaee9c796c8381439fed0fcab62810753b8b0adb1ec88fa7f41eaa5d/beartype-0.23.1.tar.gz"
    sha256 "8b805f246b32931c74f2b321ea0939fe5bb2ff43c12a3eff19cc4c854b832e1d"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/43/65/318323f98dbee45d42dff61d8f047181bc6f2268a9068cfad035a46be5af/beautifulsoup4-4.15.0.tar.gz"
    sha256 "288e3ca7d54b06f2ac191970bc275c1939cb46d450b255bf6718b04aa37ab4f7"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/cc/20/de5848b0166d8cb6b6e597b299ca10a64ebba3cf9aaab228de1e817ae85e/boto3-1.43.116.tar.gz"
    sha256 "89fa15e7d1788fb17cbd694b034beba57f43f30f58f4506913a5b62220f8ba01"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/93/98/aff05e8a35f5bb9f6648c6056ecff02a2bd4540ad70a89215db8a0cae758/botocore-1.43.116.tar.gz"
    sha256 "00b1fbfc1c024b56633538385628a1bbc7ab15aca0b5b53e5fe188841d96c8ce"
  end

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/3a/5d/15ea0494ebcb9062c7ca79bf026cbba380a50538ae73753fb40bdffa79e2/cachetools-7.2.4.tar.gz"
    sha256 "e0203b04b75fe13e62098eeb5b2018c4eb1a14c04e2b5b450e70db3ee7e92ec5"
  end

  resource "caio" do
    url "https://files.pythonhosted.org/packages/56/51/bd8b64bf700f5b1a956a60bb62276b79a094e8cd0ddc60b1b61c3edd496f/caio-0.12.9.tar.gz"
    sha256 "99e99419b44ab5511f7468c6a452887dd125b8e4042672a7589f0cf01d254ea8"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "cohere" do
    url "https://files.pythonhosted.org/packages/69/49/631a5fac290b704ba0be751d0370f8fb931ad7cb2de3c2f8e4b6a4ffb141/cohere-7.2.0.tar.gz"
    sha256 "eb74b46882dcff913f826945ae9630cee6b67237ca05d763005c4ad9c4ad5bba"
  end

  resource "ddgs" do
    url "https://files.pythonhosted.org/packages/68/30/dd2ff7d817573e30836fb99bdc04e167ce03ac5b878072b3e9e892aa810b/ddgs-9.16.0.tar.gz"
    sha256 "161ca8e78ea08d40cd3f83fb12279b49322ffb342d981368bfa39bed9847d874"
  end

  resource "distro" do
    url "https://files.pythonhosted.org/packages/fc/f8/98eea607f65de6527f8a2e8885fc8015d3e6f5775df186e443e0964a11c3/distro-1.9.0.tar.gz"
    sha256 "2fa77c6fd8940f116ee1d6b94a2f90b13b5ea8d019b98bc8bafdcabcdd9bdbed"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ef/4a/50822184bd67cc6493f0fb6a880749158fcd31ab3fa07409acfd91f9fc85/dnspython-2.9.0.tar.gz"
    sha256 "b44dc6b18f07a8b1c56676a19fbfdb5209415b046a9cece286baafa87ff3f7f1"
  end

  resource "docstring-parser" do
    url "https://files.pythonhosted.org/packages/e0/4d/f332313098c1de1b2d2ff91cf2674415cc7cddab2ca1b01ae29774bd5fdf/docstring_parser-0.18.0.tar.gz"
    sha256 "292510982205c12b1248696f44959db3cdd1740237a968ea1e2e7a900eeb2015"
  end

  resource "email-validator" do
    url "https://files.pythonhosted.org/packages/f5/22/900cb125c76b7aaa450ce02fd727f452243f2e91a61af068b40adba60ea9/email_validator-2.3.0.tar.gz"
    sha256 "9fc05c37f2f6cf439ff414f8fc46d917929974a82244c20eb10231ba60c54426"
  end

  resource "eval-type-backport" do
    url "https://files.pythonhosted.org/packages/1c/15/273a4baf8248d6d76220723c3caf039d283774b31a7c46ba686120145b76/eval_type_backport-0.4.0.tar.gz"
    sha256 "8397d25e6524c2e67b9576bb0636be27dea2192017711220c534ec2de921e9b0"
  end

  resource "exceptiongroup" do
    url "https://files.pythonhosted.org/packages/50/79/66800aadf48771f6b62f7eb014e352e5d06856655206165d775e675a02c9/exceptiongroup-1.3.1.tar.gz"
    sha256 "8b412432c6055b0b7d14c310000ae93352ed6754f70fa8f7c34141f91c4e3219"
  end

  resource "executing" do
    url "https://files.pythonhosted.org/packages/52/92/8a611141e42930c0f194f7504063ab87dfe970cf1a5af28e7703df448734/executing-2.3.0.tar.gz"
    sha256 "15919cb5d667e5cb4e099511971d00d659573fff2dd5c4e6cd8b71636c7858d2"
  end

  resource "fastavro" do
    url "https://files.pythonhosted.org/packages/d6/ee/05cae1eeb332f876a1226b382a1f1be4ac8ce66634c313f2746beadab16f/fastavro-1.13.1.tar.gz"
    sha256 "6f05aa2539bf7a19e9eb3bdaf6580c4d0f082a8230f641eaf9c84e4bcf0e6bc4"
  end

  resource "fastmcp-slim" do
    url "https://files.pythonhosted.org/packages/81/86/01705c74106297c021e5f8a22ed051adb43061cc779cf543dc05a4d47aba/fastmcp_slim-4.1.3.tar.gz"
    sha256 "d95277db0979e4cbfa84528cf9016ae079494b41ed8e88cc909fee8233db6035"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/d8/28/3893324bcadf8f89b1616637468d766af3f625008c0735bf704fdfa86617/filelock-4.2.4.tar.gz"
    sha256 "c6d8663535e1650ee430507b4ffbac7b464dd64b7647ea0112a9f406499d163d"
  end

  resource "fsspec" do
    url "https://files.pythonhosted.org/packages/77/cd/9be253869fc42e764de7f3dedd6969af7d44ff9c3375214a3442a6f3fc08/fsspec-2026.9.0.tar.gz"
    sha256 "0f08147951c8cb31d844c3547d631053b127863b60be04cf06e121333ee0e2fe"
  end

  resource "genai-prices" do
    url "https://files.pythonhosted.org/packages/ad/de/119c7ba00b9ddbf629de34cf390ab472da6d7bc5df0c51cdbec900280a74/genai_prices-0.1.13.tar.gz"
    sha256 "76c9e2dd3917fdacdf3bc562297c4591384142ea2283c477e1512fafa4e3a384"
  end

  resource "google-auth" do
    url "https://files.pythonhosted.org/packages/f5/b9/4b2528f30114b106e3c3a7298ba38d85e682fd1f83fe7c4a5b77c7677082/google_auth-2.62.0.tar.gz"
    sha256 "0bef0ce54bdf9ce226c5d66e4264413bd918141c31bbe49fb52eac882f513d69"
  end

  resource "google-genai" do
    url "https://files.pythonhosted.org/packages/d3/f9/89c95879bd58f176f82415c1a63a9dce528ea2b7a83a155412db5b1c783b/google_genai-2.32.0.tar.gz"
    sha256 "9e8fb72f0a878291bc20b941d5d535e249f5729290565b7d49406827a0c30152"
  end

  resource "googleapis-common-protos" do
    url "https://files.pythonhosted.org/packages/8d/2b/6ce81972d5c8cab9705fddce3153be63222d9e12fd96f8baba5038a744dd/googleapis_common_protos-1.75.5.tar.gz"
    sha256 "c7a866fc34ed29a3b10af627a4b9b1dc2433313ca6e959f0ae4feb132047ed72"
  end

  resource "griffelib" do
    url "https://files.pythonhosted.org/packages/2e/5f/6d93df326cbf8f9f7276be77f83c81a9c061f479abdd81f9bbec197d4b29/griffelib-2.4.0.tar.gz"
    sha256 "a277a462c56ff4479efe5cbcb4f882dc9a63cfa5ab6404a3e60957c6c8d2f7c9"
  end

  resource "groq" do
    url "https://files.pythonhosted.org/packages/0c/c1/20cb719bc21aa22df185c4aa60abc17680d7067d41fe0ca3fda98b75822b/groq-1.7.0.tar.gz"
    sha256 "d582dbb3f071b92ca339baba83af9f57ba6f46a51c34b04565d7cb9badb2785b"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/1b/ab/522a2ab67f27971a9d48ca666d4fca85ef7d5282d142e31fd087e27b1bbe/hf_xet-1.6.0.tar.gz"
    sha256 "2e58454a340b3556dfa4972d5451aff4fba8dd42a236600ba1a1d2b1514f0fef"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpcore2" do
    url "https://files.pythonhosted.org/packages/c0/61/afa9d6b7452f9eca73f73d45324eb0bb52f098fd5e6049bf6b8263be9b4e/httpcore2-2.16.0.tar.gz"
    sha256 "c72cd0413563b17e1cd8354677dff887466f8ec2551679759e93126534428643"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx2" do
    url "https://files.pythonhosted.org/packages/43/73/5ca2cedf5e4e50423d1c258877865a6b62793633b561c58499f8aeb33b7e/httpx2-2.16.0.tar.gz"
    sha256 "0d54c98128e8f2ff7fbbde0fca8c359e5f032edeaaaac443cdb7f31f685bcd7f"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/48/0f/ed994dbade67a54407c28cab96ef845e0e6d25500be56aca6394f8bfc9dd/huggingface_hub-1.16.1.tar.gz"
    sha256 "7f1dc4c5ec21aed69be630ad0c3378616be16f3de1a47b141c0e812965d9c832"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/af/50/4763cd07e722bb6285316d390a164bc7e479db9d90daa769f22578f698b4/jaraco_context-6.1.2.tar.gz"
    sha256 "f1a6c9d391e661cc5b8d39861ff077a7dc24dc23833ccee564b234b81c82dfe3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6c/1f/c23395957d41ccf27c4e535c3d334c4051e5395b3752057ba4cbaec35c56/jaraco_functools-4.6.0.tar.gz"
    sha256 "880c577ec9720b3a052d5bc611fb9f2269b3d87902ef42440df443b88e443280"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "jiter" do
    url "https://files.pythonhosted.org/packages/9c/1f/8176d92e001f86505424b41664032ae26a882bc9ca41a32c803f373f9195/jiter-0.17.0.tar.gz"
    sha256 "03e432f226a453851079fb84cd17c6da9991eab723e28d716f14ae3d906e0c12"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/d3/59/322338183ecda247fb5d1763a6cbe46eff7222eaeebafd9fa65d4bf5cb11/jmespath-1.1.0.tar.gz"
    sha256 "472c87d80f36026ae83c6ddd0f1d05d4e510134ed462851fd5f754c8c3cbb88d"
  end

  resource "joserfc" do
    url "https://files.pythonhosted.org/packages/bd/15/48ff246732232d35ee234228def22b52455fcc55577f06146602399a29b0/joserfc-1.7.7.tar.gz"
    sha256 "471d0fd12a5a0d1c0942de280f39efe6f597878315033270b504d4d006d25510"
  end

  resource "json-repair" do
    url "https://files.pythonhosted.org/packages/0b/d8/aed287ba5549e07f9688e88ba3e531cb41c966c6c44980d05e5560020b7b/json_repair-0.64.1.tar.gz"
    sha256 "7640f80e70c15862ad262cabe91d20afc3248f3187a9811b8c8d0fddd2d62f19"
  end

  resource "jsonpath-python" do
    url "https://files.pythonhosted.org/packages/98/18/4ca8742534a5993ff383f7602e325ce2d5d7cc93d72ac5e1cdedbea8a458/jsonpath_python-1.1.6.tar.gz"
    sha256 "dded9932b4ec41fb8726e09c83afa4e6be618f938c2db287cc2a81723c639671"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/43/4b/674af6ef2f97d56f0ab5153bf0bfa28ccb6c3ed4d1babf4305449668807b/keyring-25.7.0.tar.gz"
    sha256 "fe01bd85eb3f8fb3dd0405defdeac9a5b4f6f0439edbb3149577f244a2e8245b"
  end

  resource "linkify-it-py" do
    url "https://files.pythonhosted.org/packages/45/98/7a1a5f31fd5c7ba93e963b168e244b8e3dd705b3d2a718e3c3307583bf57/linkify_it_py-2.2.0.tar.gz"
    sha256 "907acd2d17ac1fbb9ddb62c8957ccbd6158cac602231a15c3b0cd1e215f03cee"
  end

  resource "logfire" do
    url "https://files.pythonhosted.org/packages/56/5a/e6cccc98d30358b8beee47c61c2a1ca66ac7a76a07de9ba333aa5219b9a6/logfire-5.2.0.tar.gz"
    sha256 "5fb9ddda303759766e86f5704a1ae96f3a0072906d52e21fbaad2e3c3b03f823"
  end

  resource "logfire-api" do
    url "https://files.pythonhosted.org/packages/3e/ef/302ecf3ea120d1ce127fae8a15ee5cfa6d178d956d253d332f49b7bc8f0c/logfire_api-5.2.0.tar.gz"
    sha256 "06553f4a4b1b54d094dd01708f51cde69ccd5e8a06fc2664bece3491b593390d"
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/23/ad/28ecd7cb894d172f3c9c80a075eeeb2017ac62e3632cee05a5f9493547eb/lxml-6.1.3.tar.gz"
    sha256 "45222d94ddd511536f3b2f7d9deae3b2339b4ce0f075f1ca25703b07cad9dd21"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "markdownify" do
    url "https://files.pythonhosted.org/packages/92/ab/d1297139c0e2ceb151ae564c8c4f57ac0155d8f1f8b4cbd5d6523c82ea36/markdownify-1.2.3.tar.gz"
    sha256 "1a176f05522c8a2cb1dd3ab9d307dcdadbed5c26ae717855bfc42b3b6d38d937"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/9d/8d/e0d339616f4810e9051d4aba6887afab289ab1f81875fe908b606cdfd0e3/mcp-2.3.0.tar.gz"
    sha256 "8b147a50441cf059dc88c684e0aeed3687f0aa0f39c6cde7b90330effd2b34d8"
  end

  resource "mcp-types" do
    url "https://files.pythonhosted.org/packages/9e/2d/7c251e34207f6c51000312fc8839111ac45cfe02023f90b44e7f1051dd8e/mcp_types-2.3.0.tar.gz"
    sha256 "d1e46549edb35ee19a94940fcee6d1addd7e589ab7ea92dda83f5d84781fc362"
  end

  resource "mdit-py-plugins" do
    url "https://files.pythonhosted.org/packages/59/fc/f8d0863f8862f25602c0404d75568e89fb6b4109804645e5cdfb1be5cf56/mdit_py_plugins-0.6.1.tar.gz"
    sha256 "a2bca0f039f39dbd35fb74ae1b5f998608c437463371f0ff7f49a19a17a114d0"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mistralai" do
    url "https://files.pythonhosted.org/packages/08/14/2b34b5537841c4f1347e6e01306dcfae0a419a4d696262411db4bf605eff/mistralai-3.3.0.tar.gz"
    sha256 "87af36e1a0bcc54acf5c02dbc7a7a2723b7fe802abd97ee317557de494828267"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/52/b8/c63995bebbb9ac9c059350e0fb8c82c2420c85aeca7d34e40aecf3df9281/more_itertools-11.2.1.tar.gz"
    sha256 "cbf08fd0af284dc69718b9b76a8e6203df624d70209ea511e4219d350c856f63"
  end

  resource "ollama" do
    url "https://files.pythonhosted.org/packages/fc/72/5f12423b6b39ca8430fbe56f77fcf4ef60f63067c7c4a2e30e200ed9ec16/ollama-0.6.2.tar.gz"
    sha256 "936d55daa684f474364c098611c933626f8d6c7d67065c5b7ae0c477b508b07f"
  end

  resource "openai" do
    url "https://files.pythonhosted.org/packages/87/4c/609b16f2a6e9a99f27a82ce93ff75868e7cb364fe6daff50cc0c1d620772/openai-3.35.1.tar.gz"
    sha256 "b33e6561b90586e450def8a388e7d364755325da6884fc71348be5542e043bd0"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/2e/02/6e0ae9cc61bd3169d401077b507b3ebc344745171e1051ab430be012dcd9/opentelemetry_api-1.45.1.tar.gz"
    sha256 "aa38ed19bcc084ba42782a73255b3582283eced7ad6dddbd6695189e69adfb75"
  end

  resource "opentelemetry-exporter-http-transport" do
    url "https://files.pythonhosted.org/packages/62/0c/e3ebdb4b507f66afcc905e6885a4946969bd75b45988492643356fbbdc63/opentelemetry_exporter_http_transport-0.66b1.tar.gz"
    sha256 "443080203bf52586ce0b2ad901e8951c61833eab1aa539ae6f1f16fe9e8e7952"
  end

  resource "opentelemetry-exporter-otlp-common" do
    url "https://files.pythonhosted.org/packages/cb/19/41de712173f43057e4532d42ece7d0c6d4210d353e5752433cb14987643f/opentelemetry_exporter_otlp_common-0.66b1.tar.gz"
    sha256 "6b1403487a2185ac1feb45fd5546fdf8630ce71c36bcefaadf51e2130e9e23f9"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https://files.pythonhosted.org/packages/c1/8e/65e85e5137991a3c493b11682151d198638a5bc1dd4b4c5f67e013c57d7c/opentelemetry_exporter_otlp_proto_common-1.45.1.tar.gz"
    sha256 "2e4adcc3a67bcf57804fc49514f0ef64974ca7590aa3491da389852b4a0628f6"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https://files.pythonhosted.org/packages/1b/17/26487707ea4caa97b17e6e4b5fa72133a53512ffa2f5cf7a49ef284b29cb/opentelemetry_exporter_otlp_proto_http-1.45.1.tar.gz"
    sha256 "45c218405ce3fd879596924b1874bf9a8f6880206d61065c5a912c8e5c297fb7"
  end

  resource "opentelemetry-instrumentation" do
    url "https://files.pythonhosted.org/packages/a5/03/89e47ff8d52a4f83b343e6eb9ef1698ff45357216e5b6b2b21e0da5c5c7d/opentelemetry_instrumentation-0.66b1.tar.gz"
    sha256 "e79a510f7d87c72d95e964ddb42193a0d9a75668c027d980eab032ea1322a5ce"
  end

  resource "opentelemetry-instrumentation-httpx" do
    url "https://files.pythonhosted.org/packages/de/50/41544799b043d14fdfa6fe62fa2518eaba22793fce03e9abde930b92e671/opentelemetry_instrumentation_httpx-0.66b1.tar.gz"
    sha256 "5865a72c68098c85955a271ab8744b480a36e3ee492d35b8cadb93c7c4dbb618"
  end

  resource "opentelemetry-proto" do
    url "https://files.pythonhosted.org/packages/4b/7f/15f014fb195da6c2dbb6c71399b8e76824878718e94de6454038488eed28/opentelemetry_proto-1.45.1.tar.gz"
    sha256 "79e0fb95e4616691a469439238aa9224d75779b3e108e895d1aa125ab29ca77c"
  end

  resource "opentelemetry-sdk" do
    url "https://files.pythonhosted.org/packages/a1/79/7392e21a1c8f0c61d90b223e31c7e48cb9d452e91a6b820ad24cca5f23c4/opentelemetry_sdk-1.45.1.tar.gz"
    sha256 "63d24a6ca645019a631e6a51999c73e93adcac1196ca640b8ae78a7cc4762bf3"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https://files.pythonhosted.org/packages/46/e4/dbbfb2a010c4db2224a5114638acede6fe563d33cc20fb1752cebcbe6298/opentelemetry_semantic_conventions-0.66b1.tar.gz"
    sha256 "497ca63bf383723411e8eaf60c8779e9877633c936bb641080adab59d0eb6ec8"
  end

  resource "opentelemetry-util-http" do
    url "https://files.pythonhosted.org/packages/7c/b5/df4b61da899f6ebdffdbdf0c8b0f3189ee57151694ccd5b7d50ee2906241/opentelemetry_util_http-0.66b1.tar.gz"
    sha256 "047dea1a628031f857a5a32261dc0e955bc162d39993ed1cffb8f2cff5ba8a62"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/7d/fa/3944b40b07da9ce895c0e6303a5ab7d53da063554f534556b134a54d6093/packaging-26.3.tar.gz"
    sha256 "94edc256424af38762eb31306eed28beb9f0efc50a8837492c9d6fd6004aed79"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/58/e6/d0abbb256b44e6a05748c6942511ff67db8dbb068de0c35b24bf1b395b09/platformdirs-4.13.5.tar.gz"
    sha256 "05831adf87d392760f4b5c3a0a95579ab5a10b18b9b9bd43680dcb47544788a0"
  end

  resource "primp" do
    url "https://files.pythonhosted.org/packages/c7/01/c2a43378aaaf29539971766a007f3185fbe3f208f431b0969fa85c5a2111/primp-2.0.1.tar.gz"
    sha256 "82ba17b077bef19a189d9ec8d77ca632496cb444e0f4fa37e27e90041cf0da8f"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "py-key-value-aio" do
    url "https://files.pythonhosted.org/packages/ca/99/c346e3474853801ec5ecf4c3ee60cfc6060327ebc31424df4e346620dde4/py_key_value_aio-0.4.6.tar.gz"
    sha256 "267c03c3e24cb99d3097612f8a5cfd8e11785c6a2975e272db0e303ea1850bfd"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/9a/23310166d960def5897e91fe20e5b724601b02a22e84ba1f94232c0b7f67/pyasn1-0.6.4.tar.gz"
    sha256 "9c447d8431c947fe4c8febc4ed9e760bc29011a5b01e5c74b67025bd9fb8ce81"
  end

  resource "pyasn1-modules" do
    url "https://files.pythonhosted.org/packages/e9/e6/78ebbb10a8c8e4b61a59249394a4a594c1a7af95593dc933a349c8d00964/pyasn1_modules-0.4.2.tar.gz"
    sha256 "677091de870a80aae844b1ca6134f54652fa2c8c5a52aa396440ac3106e941e6"
  end

  resource "pydantic-ai-harness" do
    url "https://files.pythonhosted.org/packages/09/e3/3bba6cac3863e3a7e3d56b14b939138cb559a267b6ec629f491adc3b3704/pydantic_ai_harness-0.59.0.tar.gz"
    sha256 "1036b93109b8e617909612e7877016332124a57fb609c1787b2d7bb5b96bff84"
  end

  resource "pydantic-ai-slim" do
    url "https://files.pythonhosted.org/packages/c3/1e/cd44ec11b296ec93fb9412f9aaef2b265f60e49a75b49cc0b2c6b1aa60fd/pydantic_ai_slim-2.59.0.tar.gz"
    sha256 "ce441e646dd79a8dd80ef19c9f6821d803857f08870b260b61db5e8e7af95010"
  end

  resource "pydantic-graph" do
    url "https://files.pythonhosted.org/packages/e0/36/f00e344d48ab0065b5d93692dcd6245f4400dc946140b1fdc56657deb5d8/pydantic_graph-2.59.0.tar.gz"
    sha256 "f8cf18e18cdea6c6ee412017373c156e4fadc0b4b205c174d564d878d1765989"
  end

  resource "pydantic-settings" do
    url "https://files.pythonhosted.org/packages/05/ca/7817b4bf0c4b15c6a6ab8cdf4cb96c268335a8ca2f525de93b6ebe4c7d28/pydantic_settings-2.16.1.tar.gz"
    sha256 "aff602a1886338c2df3d1e958e2193a8dc33cec75b91f202e83fd98484b4b0da"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  resource "pyjwt" do
    url "https://files.pythonhosted.org/packages/43/ea/5194e52748b0da83d71e082d75496eaec6e58f419f5e184786ded517e6a9/pyjwt-2.15.1.tar.gz"
    sha256 "4f259e80cdfb6b3fc18a7de51fd1ef9ec79652f25019bae68975ca2468a34df8"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/6a/53/ed9d74092561d4b01a2ef1349d52cdbc135e526c245f366b089cfca6de49/python_dotenv-1.2.3.tar.gz"
    sha256 "a20a594dabeaa385725aa239d5244871c143ecb356add8a20fcf23773a6c3a35"
  end

  resource "python-multipart" do
    url "https://files.pythonhosted.org/packages/5b/42/55c32bb9b12693c092ad250a0e82edb5b31ddeda6eb772de5f308b3804ad/python_multipart-0.0.32.tar.gz"
    sha256 "be54b7f3fa167bb83e4fcd936b887b708f4e57fe75911c02aebf53efaf8d938e"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/fc/f2/af1da9d3ceed77bfcdce40427d49ba0be94e4fe84245e3bfef68c10e75b6/regex-2026.9.29.tar.gz"
    sha256 "8b5fcc4771732191b2b7d1dd68d8f0353f47f8d90b6150f6dce58bf1112442cb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/ac/c3/e2a2b89f2d3e2179abd6d00ebd70bff6273f37fb3e0cc209f48b39d00cbf/requests-2.34.2.tar.gz"
    sha256 "f288924cae4e29463698d6d60bc6a4da69c89185ad1e0bcc4104f584e960b9ed"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/c0/8f/0722ca900cc807c13a6a0c696dacf35430f72e0ec571c4275d2371fca3e9/rich-15.0.0.tar.gz"
    sha256 "edd07a4824c6b40189fb7ac9bc4c52536e9780fbbfbddf6f1e2502c31b068c36"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/49/c5/0a5ce655109cb96b8dfad36908a4e108d15f5dc2eff8fbc3146c4312e704/s3transfer-0.19.3.tar.gz"
    sha256 "8326acc3d056d7f7b8a37110c7d2aea41f67e83f6ae79cd3b5fbcca34c726406"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/1c/03/e834bcd866f2f8a49a85eaff47340affa3bfa391ee9912a952a1faa68c7b/secretstorage-3.5.0.tar.gz"
    sha256 "f04b8e4689cbce351744d5537bf6b1329c6fc68f91fa666f60a380edddcd11be"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/5e/77/2dcfa996b01702ab8fd0763d84098f6a640d6162a328f1c04c2697579a1a/soupsieve-3.0.3.tar.gz"
    sha256 "7dcf6022eed0399eb9934a75e020148f7a2024c37b7dfcd3cf2c5505d69c364e"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/e4/be/0123026f719d1a7936f214a88b553bb5701e04ff2511147c1dab0c5035eb/sse_starlette-3.5.0.tar.gz"
    sha256 "75de713aa8a9441513cc283220826da079d982770965b951e9437720e8bafdb2"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/ad/eb/4e197bf26b023abafc5e9043ec8710d7de0fcb032d0969045236d72aa0b1/starlette-1.9.0.tar.gz"
    sha256 "3d931de246ed870e35ce605974440816ef895e592f255d1396cfdf191d4c4318"
  end

  resource "tenacity" do
    url "https://files.pythonhosted.org/packages/47/c6/ee486fd809e357697ee8a44d3d69222b344920433d3b6666ccd9b374630c/tenacity-9.1.4.tar.gz"
    sha256 "adb31d4c263f2bd041081ab33b498309a57c77f9acf2db65aadf0898179cf93a"
  end

  resource "terminaltexteffects" do
    url "https://files.pythonhosted.org/packages/3c/df/4fa04990d75cc27215159bf9edec7d56546fd72e1927c5753d0de0414e7b/terminaltexteffects-0.15.0.tar.gz"
    sha256 "f4b31c86bfa943d5bf3b2c5ecbfaea0de65ed4a951028c40f8e4cb54efd06439"
  end

  resource "textual" do
    url "https://files.pythonhosted.org/packages/00/21/39a76b01bd5eea82a04baaca7580e105d8c59450df03998345bb2cfb307b/textual-8.2.8.tar.gz"
    sha256 "3f106a9fbc73e39dd266c9712432087de78a6d644084c7c241d6a25c3169115b"
  end

  resource "textual-image" do
    url "https://files.pythonhosted.org/packages/c2/e7/c82ea0604874b6d51d5717a0911061ae5810e36dad2e4d2b11fa7d54cdaa/textual_image-0.12.0.tar.gz"
    sha256 "fdd0b5ff9c8a99740bc360a99ce014d563fa97d07a5b49b472470809f57c0a74"
  end

  resource "textual-speedups" do
    url "https://files.pythonhosted.org/packages/d4/73/bba3e9feae9ca730c32122306ddac61278a8bc47633346eddad9d52a435d/textual_speedups-0.2.1.tar.gz"
    sha256 "72cf0f7bdeede015367b59b70bcf724ba2c3080a8641ebc5eb94b36ad1536824"

    patch do
      url "https://github.com/willmcgugan/textual-speedups/commit/acb510d0dafa82ca1bd4291a880c6785b96be5f3.patch?full_index=1"
      sha256 "7eeb90dbfc3ecb903827c61314941b590f105279b297c8eb57bb664be916f26e"
      type :unofficial
      resolves "https://github.com/willmcgugan/textual-speedups/pull/11"
    end
  end

  resource "textualeffects" do
    url "https://files.pythonhosted.org/packages/cc/40/5d28a460c8b3fb071df67dd0fbf1125b0373d0ef5a9105e6a146bacc530d/textualeffects-0.2.0.tar.gz"
    sha256 "e42f3865dbdc815831ae8159c9c39d1dd0789b2dea2bc6f8c15c43e2477e5df1"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/66/62/167a842aa0429d45f5e797354fd4343a96f6043d67d0513c675c7b8d36e6/tiktoken-0.14.0.tar.gz"
    sha256 "231dec90efcdccf1b565a1416107736f1e09b1a08fe736ef9d6363e626d03874"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/e0/7c/2cabb2174e772636683008f2c5621949b645da7d303c596589e84516a184/tokenizers-0.23.3.tar.gz"
    sha256 "cded33237c77caeef62944d32aa9a7ef42bdce2b3497e18d137e072a8c4be438"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "truststore" do
    url "https://files.pythonhosted.org/packages/ee/9f/c5201d42a484c061e528825fc8e2d565f5abd50a4ced6fb7d29c4ec99b2b/truststore-0.10.5.tar.gz"
    sha256 "30d36967ccaded5cbb38d602c433f53600036c79d502f4533a49b60a03bbefcd"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/16/f7/57713ba479fd405eb76de31404b2c744c289e336b2d999511ebf51e496f7/typer-0.27.2.tar.gz"
    sha256 "269b7eb9d3c202ca84b4bc9618cb04ebb43d3d4d1e567e4c768607232c05f945"
  end

  resource "types-requests" do
    url "https://files.pythonhosted.org/packages/57/15/9b7e2e2e7c87d01366185b198b3febc6bc0c973f2bf21a62da4ab7d3495e/types_requests-2.33.0.20261006.tar.gz"
    sha256 "0652999e9306aea345f40732d58fa49a7f6cade6a0d74d92119c5c8d82eddaf0"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e3/05/b17359e1cefb4f909b5e40b1b90a496d987258916dbbf88e842c729f510e/urllib3-2.8.0.tar.gz"
    sha256 "63bf2ead4c879426ebf22ef2a781eeb4aa3b4ae798a0435506f8687fd5bb9b63"
  end

  resource "uvicorn" do
    url "https://files.pythonhosted.org/packages/da/34/30e9280707135d2cfc589dfff3cb796bd07a3aeb1a3e415ba09dd89d7bb4/uvicorn-0.54.0.tar.gz"
    sha256 "a2e33cbfaa0306f8e6b0c13e0cb89d7d7a2da3e62b90c66e18c33d9807b28620"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/21/f7/bc3a25c5ec26ce62ce487690becc2f3710bbc7b33338f005ad390db0b986/websockets-16.1.1.tar.gz"
    sha256 "db234eda965dcce15df96bb9709f587cd87d4d52aaf0e80e2f34ec04c7670c57"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/04/22/89e2f3bdae5cb34e0cab0cd86d7172dbf418de4b46c9b17b9c7a560dfa44/wrapt-2.5.1.tar.gz"
    sha256 "f595bb0185aab3e9dc31950c95d914f56ea8278810c3b928f3426e12ed6d27bc"
  end

  def install
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG for primp
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"
    # `tokenizers` and `hf-xet` build PyO3 extensions through maturin.
    ENV.append_to_rustflags "--codegen link-arg=-Wl,-undefined,dynamic_lookup" if OS.mac?

    without = ["hf-xet"]
    without += %w[jeepney secretstorage] unless OS.linux?
    venv = virtualenv_install_with_resources(without:)

    resource("hf-xet").stage do
      # Use native-tls rather than needing to build another rustls + aws-lc
      inreplace %w[xet_client/Cargo.toml xet_data/Cargo.toml xet_pkg/Cargo.toml],
                'default = ["rustls-tls"]', 'default = ["native-tls"]'
      venv.pip_install Pathname.pwd
    end

    generate_completions_from_executable(bin/"oterm", shell_parameter_format: :typer)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oterm --version")
    assert_match "EnvConfig", shell_output("#{bin}/oterm --config")
  end
end