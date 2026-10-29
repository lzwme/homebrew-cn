class RapidMlx < Formula
  include Language::Python::Virtualenv

  desc "Fast local AI engine for Apple Silicon with an OpenAI-compatible API"
  homepage "https://github.com/raullenchai/Rapid-MLX"
  url "https://files.pythonhosted.org/packages/be/b8/f2bf2ebfd26b5f29f006862fc9d2f1e0dac23e845dc7b4a40a7f90a89978/rapid_mlx-0.16.10.tar.gz"
  sha256 "527f149cbc468ed5c11cc0e3ae73c1ab217e4f6b6e5bd1c282f513ac84578db0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f12ea8de853c88ec797814edfe48110ebd7d601a5eb72502e33608b1ad011b21"
    sha256 cellar: :any, arm64_tahoe:       "0c5119d909bd2ae37690f51436156becc8a92932aca4e3741f07529664607439"
    sha256 cellar: :any, arm64_sequoia:     "35d269e1efd429d6fb5fc2e0305e465f26e7496f25c899d652c6adeda3950992"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "ffmpeg"
  depends_on "libsndfile"
  depends_on "libyaml"
  depends_on macos: :sonoma
  depends_on "mlx"
  depends_on "numpy"
  depends_on "opencv" => :no_linkage
  depends_on "pillow" => :no_linkage
  depends_on "portaudio"
  depends_on "pydantic" => :no_linkage
  depends_on "python-matplotlib" => :no_linkage
  depends_on "python@3.15"
  depends_on "pytorch" => :no_linkage
  depends_on "rpds-py" => :no_linkage
  depends_on "scipy" => :no_linkage
  depends_on "sentencepiece" => :no_linkage
  depends_on "torchvision" => :no_linkage

  # mflux only requires hf-transfer to avoid an error in huggingface-hub < 1.0, which no longer uses it.
  pypi_packages exclude_packages: %w[
    certifi cryptography hf-transfer matplotlib mlx numpy opencv-python pillow pydantic rpds-py scipy
    sentencepiece torch torchvision
  ]

  resource "annotated-doc" do
    url "https://files.pythonhosted.org/packages/5a/8e/38aa427ed5402449e226975b649c5dc73ccadfefeb95e6aecb8f8ea4b6b6/annotated_doc-0.0.5.tar.gz"
    sha256 "c7e58ce09192557605d8bbd92836d7e1d520ac9580096042c0bfd197efacf1bb"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/a9/d2/f4d173e22df740bc37b1db102b386ba719b66e95b0f0d751f556b387e6d2/anyio-4.15.1.tar.gz"
    sha256 "9f28306018cbd6d329e64a36d58256edff76dd996fe423bc957326e578b82a94"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/87/6f/5a73f04007ca950701765949209f068da628bd11f9c2da287278ce91e0ee/argcomplete-3.7.2.tar.gz"
    sha256 "aad8b69a0b9969edb62db0d1752354c0d50717b10e0cbb00e2a958381b9fc6b9"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/33/1c/f41d4e74c28ab327ff3acd36053f7ea506c55872d7a90b0fa71aa3ab0c89/charset_normalizer-3.5.2.tar.gz"
    sha256 "39de2a259fc954455c57274dc94c79d5842774e1247a016aff30bc0efed0f4ef"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/c7/0e/7fa0ef50764b67090eca4114772a2abf8b6148198475e54c660b97caeee6/click-8.5.0.tar.gz"
    sha256 "ba0d2089de75ea0310e2dde03160e6ca10009947fb95a182f9b54021bb272e34"
  end

  resource "fastapi" do
    url "https://files.pythonhosted.org/packages/e9/eb/2cf8c80abf09b2800aef0a83b41066fbfda8ee5495b7a08b9d1af40f7046/fastapi-0.162.0.tar.gz"
    sha256 "6a22c1e2e6e32e0633ee7e170f00009a29b8228b16feb219ee42f32fd8d88a8f"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/01/ee/02a2c011bdab74c6fb3c75474d40b3052059d95df7e73351460c8588d963/h11-0.16.0.tar.gz"
    sha256 "4e35b956cf45792e4caa5885e69fba00bdbc6ffafbfa020300e549b208ee5ff1"
  end

  resource "hf-xet" do
    url "https://files.pythonhosted.org/packages/9e/27/06d899ea7bd721d272f84aac98bdb238de98af4cc767a69056d967d68c71/hf_xet-1.7.0.tar.gz"
    sha256 "d406ec79053c0871817f700c2ac8c36ba0d87f9c34b7458b0f0063bb218b0466"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/06/94/82699a10bca87a5556c9c59b5963f2d039dbd239f25bc2a63907a05a14cb/httpcore-1.0.9.tar.gz"
    sha256 "6e34463af53fd2ab5d807f399a9b45ea31c3dfa2276f15a2c3f00afff6e176e8"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "httpx-sse" do
    url "https://files.pythonhosted.org/packages/0f/4c/751061ffa58615a32c31b2d82e8482be8dd4a89154f003147acee90f2be9/httpx_sse-0.4.3.tar.gz"
    sha256 "9b1ed0127459a66014aec3c56bebd93da3c1bc8bb6618c8082039a44889a755d"
  end

  resource "huggingface-hub" do
    url "https://files.pythonhosted.org/packages/25/2a/484d112c0d8fc5f665d7b65137ac9cdb2953c982391598c3597968a12ee7/huggingface_hub-1.33.0.tar.gz"
    sha256 "367be21a201db9523eddf8aeac7048f2602c1b308691c97640d5e72ed188007e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f5/08/8eea9d4b8302028f3abb2c0813953f7aec26d33b7a8960ed760e65ff29fa/idna-3.20.tar.gz"
    sha256 "a7db850025b95ded1eae8a46181a1a6c56c92c96f0e2b005d9ff8dc0210cab44"
  end

  resource "imageio" do
    url "https://files.pythonhosted.org/packages/f3/cd/69e4ac55b6dafdd2b5f32075236841a3945dea7323d0232d80f28c37cea8/imageio-2.38.1.tar.gz"
    sha256 "6769f1f01c4dd46448307863a787c9a22fa4dbe11c0c88f525c6e410fdfd7983"
  end

  resource "imageio-ffmpeg" do
    url "https://files.pythonhosted.org/packages/44/bd/c3343c721f2a1b0c9fc71c1aebf1966a3b7f08c2eea8ed5437a2865611d6/imageio_ffmpeg-0.6.0.tar.gz"
    sha256 "e2556bed8e005564a9f925bb7afa4002d82770d6b08825078b7697ab88ba1755"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/b3/fc/e067678238fa451312d4c62bf6e6cf5ec56375422aee02f9cb5f909b3047/jsonschema-4.26.0.tar.gz"
    sha256 "0c26707e2efad8aa1bfc5b7ce170f3fccc2e4918ff85989ba9ffa9facb2be326"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "llguidance" do
    url "https://files.pythonhosted.org/packages/1e/2e/3b0e13c1e01d5598708a6e7b77c55f3ae9c6c4e242a50a239f03ee800630/llguidance-1.9.1.tar.gz"
    sha256 "3ba1b37585d07f50bb73e06dca6d45c88c9d5801789c071c8ff784c9dbcc5c46"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/06/ff/7841249c247aa650a76b9ee4bbaeae59370dc8bfd2f6c01f3630c35eb134/markdown_it_py-4.2.0.tar.gz"
    sha256 "04a21681d6fbb623de53f6f364d352309d4094dd4194040a10fd51833e418d49"
  end

  resource "mcp" do
    url "https://files.pythonhosted.org/packages/ba/93/0142dc84a666daf8ad51a34268f34c12fd6fda4f3810c4be2504eecc8212/mcp-1.30.0.tar.gz"
    sha256 "445414625fce5c295faa505bb11bacece661ab6f4028d57c935db57820b7a3e4"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mflux" do
    url "https://files.pythonhosted.org/packages/7f/08/33ff2acce0f84e51f6c86b6a8d33b4e6703ef485a5d9c40a9e1ebe9af797/mflux-0.20.0.tar.gz"
    sha256 "8fec3407bbc821cfba9cebd8ae55e35450b9429ec9b5445c9557aaeb78087de0"
  end

  resource "miniaudio" do
    url "https://files.pythonhosted.org/packages/d8/d5/e5439dc08561f73656bfeb3340fc64ab63163e101426593d8fb9a025ff1e/miniaudio-1.71.tar.gz"
    sha256 "ff51e2887bb673e2e757752b586b3dc924d59aa5fbcae9bbc45f4a111bd3262b"
  end

  resource "mlx-arsenal" do
    url "https://files.pythonhosted.org/packages/5b/c5/2fc249eb89b2399a4db86c7b60f45aca239a3035e877b2129958ae44dbe1/mlx_arsenal-0.12.1.tar.gz"
    sha256 "2009d801750e6d1b8f9ecbb75e08b2b6e5dd02ccf864a63b518df90da002f940"
  end

  resource "mlx-audio" do
    url "https://files.pythonhosted.org/packages/64/87/094d4b5fbbd8901b45f3c69290a8ecd1d5c5e72a7f9dba88549d195975b0/mlx_audio-0.6.2.tar.gz"
    sha256 "ac43270632ce86370d17c54236e906e50ba19f0e6412b1f5e43646f3680ae8a5"
  end

  resource "mlx-lm" do
    url "https://files.pythonhosted.org/packages/84/94/9a38d6b0c6fcca995b9136c94eb7da1e9c5165652edf228b96b29960fa7a/mlx_lm-0.31.3.tar.gz"
    sha256 "61eb0e3ba09444f77f874aff295401d7ccd20b39495cbbce0c782a15474ce733"
  end

  resource "mlx-video-with-audio" do
    url "https://files.pythonhosted.org/packages/a0/df/91a078be06fba6ebd15752465070a133fcb49fc042e2199403641e769435/mlx_video_with_audio-0.1.36.tar.gz"
    sha256 "6c7ea0fd31db8f3f4677f3a0650deb0b558912d889113c31fc51c812acb70c4c"
  end

  resource "mlx-vlm" do
    url "https://files.pythonhosted.org/packages/c0/5b/7c90976c8dd038c1260873d85d0b4270948c06abc0a216f2e15fa3879e9c/mlx_vlm-0.7.2.tar.gz"
    sha256 "6d6305cf4f82be4443c20a7dca74fc1116738ecaece42c0e3ff57ae4aea3e156"
  end

  resource "openai-harmony" do
    url "https://files.pythonhosted.org/packages/3e/92/2d038d096f29179c7c9571b431f9e739f87a487121901725e23fe338dd9d/openai_harmony-0.0.8.tar.gz"
    sha256 "6e43f98e6c242fa2de6f8ea12eab24af63fa2ed3e89c06341fb9d92632c5cbdf"
  end

  resource "opentelemetry-api" do
    url "https://files.pythonhosted.org/packages/2e/02/6e0ae9cc61bd3169d401077b507b3ebc344745171e1051ab430be012dcd9/opentelemetry_api-1.45.1.tar.gz"
    sha256 "aa38ed19bcc084ba42782a73255b3582283eced7ad6dddbd6695189e69adfb75"
  end

  resource "piexif" do
    url "https://files.pythonhosted.org/packages/fa/84/a3f25cec7d0922bf60be8000c9739d28d24b6896717f44cc4cfb843b1487/piexif-1.1.3.zip"
    sha256 "83cb35c606bf3a1ea1a8f0a25cb42cf17e24353fd82e87ae3884e74a302a5f1b"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/1a/43/8c4b5fe23f0e119cf4e1b16c2d16240ab9057cdbb138568c91d5a48abf81/platformdirs-4.13.6.tar.gz"
    sha256 "211d176e24674b5895dedf9021c262bcf9fad008a70610bfb147d4a8d6d8fe1b"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d9/89/5b8517baa72f84a67b8a307ba953c91057af618bf40bf676f3c03551f8f0/protobuf-7.36.2.tar.gz"
    sha256 "497d0463ff3316681da6c0b9e8d06cb465d61abce00b613ab42226175644d1bb"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/aa/c6/d1ddf4abb55e93cebc4f2ed8b5d6dbad109ecb8d63748dd2b20ab5e57ebe/psutil-7.2.2.tar.gz"
    sha256 "0746f5f8d406af344fd547f1c8daa5f5c33dbc293bb8d6a16d80b4bb88f59372"
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

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/06/28/081f1cbcca7042441dafc8de00f48ba60853f89e5bff92c5f26477346d81/pypdf-6.21.2.tar.gz"
    sha256 "0a3e1c5c886a1be03646c16a04827cc166c2a0575c971b26a4bf89686551c2d4"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/74/26/2fbeedb218a787a5eea551c7532cac4e009f83d689dd2faa0d0353473f86/python_dotenv-1.2.4.tar.gz"
    sha256 "f0d53e69935a851c0dcc78f3ab7aaccd8cabef0b92382b576b824212902873c0"
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

  resource "safetensors" do
    url "https://files.pythonhosted.org/packages/45/06/f955dbbb1859e3bd23c8ac6141af5106e7ad5fedec4a3a6e3d60f94b7001/safetensors-0.8.0.tar.gz"
    sha256 "fabaf3e0f18a6618d9b36560682562157f77c2b71fcffc7b432be2baed9d753d"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/58/15/8b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58e/shellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sounddevice" do
    url "https://files.pythonhosted.org/packages/ec/db/0c890e2d9aab9ba284021efc02e1d3aebfecab1b611762d7434602209bcf/sounddevice-0.5.6.tar.gz"
    sha256 "8ec9fbfde2e32f020b167e348f3ab3bac6625a5f15af524d790108ac7147a410"
  end

  resource "soundfile" do
    url "https://files.pythonhosted.org/packages/d2/db/949331952a6fb1c5b12e9de80fd08747966c2039d1a61db4764fbd3981c2/soundfile-0.14.0.tar.gz"
    sha256 "ba1c1a2d618bca5c406647c83b89f07cc8810fa506a50622a6993ba130c1de11"
  end

  resource "sse-starlette" do
    url "https://files.pythonhosted.org/packages/71/7f/3b8ec4f27833f7b8c270a3ef960b6d435e1065439847bc0fcd1e58ae898b/sse_starlette-3.6.0.tar.gz"
    sha256 "623151d6c20dc0eebf1b3379c27faae91fff883bac7ab6665f16f46440a88b3a"
  end

  resource "starlette" do
    url "https://files.pythonhosted.org/packages/48/bb/3d8757f21e9a53d9035c9eb039a777047139a16bfdbedfc7a58241c3d914/starlette-1.10.0.tar.gz"
    sha256 "b8399098d4c1e3522734f7235dc79b1fc967f96cf139c81e0fa30479e0685f9b"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/46/58/8c37dea7bbf769b20d58e7ace7e5edfe65b849442b00ffcdd56be88697c6/tabulate-0.10.0.tar.gz"
    sha256 "e2cfde8f79420f6deeffdeda9aaec3b6bc5abce947655d17ac662b126e48a60d"
  end

  resource "tiktoken" do
    url "https://files.pythonhosted.org/packages/e4/e5/5f3cb2159769d0f4324c0e9e87f9de3c4b1cd45848a96b2eb3566ad5ca77/tiktoken-0.13.0.tar.gz"
    sha256 "c9435714c3a84c2319499de9a300c0e604449dd0799ff246458b3bb6a7f433c1"
  end

  resource "tokenizers" do
    url "https://files.pythonhosted.org/packages/73/6f/f80cfef4a312e1fb34baf7d85c72d4411afde10978d4657f8cdd811d3ccc/tokenizers-0.22.2.tar.gz"
    sha256 "473b83b915e547aa366d1eee11806deaf419e17be16310ac0a14077f1e28f917"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "tomli-w" do
    url "https://files.pythonhosted.org/packages/19/75/241269d1da26b624c0d5e110e8149093c759b7a286138f4efd61a60e75fe/tomli_w-1.2.0.tar.gz"
    sha256 "2dd14fac5a47c27be9cd4c976af5a12d87fb1f0b4512f81d69cce3b35ae25021"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/0d/ea/b2a5bd54b28a324dae8211928b2d730b6547500342c7e6c6dea08bd0a485/tqdm-4.70.1.tar.gz"
    sha256 "cefd0eca11b2a37a3aee776544d4f4ae913f02688135b5556b8788dfa474afc4"
  end

  resource "transformers" do
    url "https://files.pythonhosted.org/packages/2a/92/c50c61da7046bbb59a4d011291aeadcfb4d7980ab36fdb31e93823a3fb93/transformers-5.15.1.tar.gz"
    sha256 "27c996bd9075ddc82d40f8590dfdc81ea45f611bfca477e0db5d7fd257a482f7"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/03/51/d33db42cc72ffd8c30777547b42d01f0cbf9d95a770457698d0174b3ed71/typer-0.27.3.tar.gz"
    sha256 "d0396f770a560ab1b0a8504e13b5f254b728cedb05c61cf0359e944e50ce8901"
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
    url "https://files.pythonhosted.org/packages/30/4b/4692be6d5bf739ed049b3813901c42091f8c054df89d5c089343823dea0d/websockets-17.3.tar.gz"
    sha256 "1c7dd93a1c9f89297471493674b1fc1d9467cafd45374f2172213046bdb3a329"
  end

  def install
    # Work around superenv breaking aws-lc-sys `-O0` needed to build CPU Jitter RNG
    ENV["AWS_LC_SYS_NO_JITTER_ENTROPY"] = "1"
    # `tokenizers`, `hf-xet` and `openai-harmony` build PyO3 extensions through maturin.
    ENV.append_to_rustflags "-C link-arg=-Wl,-undefined,dynamic_lookup"

    venv = virtualenv_install_with_resources(without: "hf-xet")

    # Use brewed portaudio instead of sounddevice's bundled cross-platform libraries.
    sounddevice_lib = venv.site_packages/"_sounddevice_data/portaudio-binaries"
    rm_r sounddevice_lib
    sounddevice_lib.install_symlink formula_opt_lib("portaudio")/shared_library("libportaudio")

    resource("hf-xet").stage do
      # Use native-tls rather than needing to build another rustls + aws-lc
      inreplace %w[xet_client/Cargo.toml xet_data/Cargo.toml xet_pkg/Cargo.toml],
                'default = ["rustls-tls"]', 'default = ["native-tls"]'
      venv.pip_install Pathname.pwd
    end

    # These formulae install their Python modules in separate virtual environments.
    site_packages = Language::Python.site_packages(python3)
    (venv.site_packages/"homebrew-pytorch.pth").write "#{formula_opt_libexec("pytorch")/site_packages}\n"
    (venv.site_packages/"homebrew-torchvision.pth").write "#{formula_opt_libexec("torchvision")/site_packages}\n"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rapid-mlx --version")
    assert_match "qwen3.5-4b-4bit", shell_output("#{bin}/rapid-mlx info qwen3.5-4b-4bit")
    system libexec/"bin/python", "-c", <<~PYTHON
      import cv2, imageio_ffmpeg, torch, torchvision
      imageio_ffmpeg.get_ffmpeg_exe()
    PYTHON
  end
end