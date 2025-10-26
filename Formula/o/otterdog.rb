class Otterdog < Formula
  include Language::Python::Virtualenv

  desc "Manage GitHub organizations at scale using an infrastructure as code approach"
  homepage "https://otterdog.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/68/d8/4c1827aa29bc22f4a8f4cb4a755f4505c7e84fc54a6a67e3a5bbd4dc0389/otterdog-1.1.0.tar.gz"
  sha256 "b1dc49d7cd0b4f077aa84d924299412539960cb848efbfbe69d9689adebc4832"
  license "EPL-2.0"
  head "https://github.com/eclipse-csi/otterdog.git", branch: "main"

  # https://github.com/microsoft/playwright-python/issues/2579
  no_autobump! because: "'playwright' resource lacks PyPI sdist"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "99257156b6700723367104827453d2e0a2d5462b282f60347aeb89bae0197b4d"
    sha256 cellar: :any,                 arm64_sequoia: "5f20c8552aaa1072a66810ae512dbd92092aab3c0f1e4df8d948e0fe4d0c98f2"
    sha256 cellar: :any,                 arm64_sonoma:  "6de91da57b2653adf2ca824839cb9a5d4cf5b685707af6366dbc5f97cb74cf27"
    sha256 cellar: :any,                 sonoma:        "ecf9448d0afa3f620adf426933e9590dfce2d3fcb5504b4dc8ba856df5881f3e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0f4f6de5036111648e2da764c6f8ac7272c4e82d25ead2b5849dc16b94991850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec43bd12f2a973a9448ac8ea8e635cdd32d8a62103f1684cba6cf26c9d86e283"
  end

  depends_on "rust" => :build # for rjsonnet
  depends_on "certifi" => :no_linkage
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium"
  depends_on "python@3.14"
  depends_on "rpds-py" => :no_linkage

  # No sdist on PyPI, so we use the GitHub tarball
  # Ref: https://github.com/microsoft/playwright-python/issues/2579
  resource "playwright" do
    url "https://ghfast.top/https://github.com/microsoft/playwright-python/archive/refs/tags/v1.55.0.tar.gz"
    sha256 "adda41b4a6c02f414d535b7a0e03bc5f4c4f77fb3d4ef3028f8b609ca71f3613"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/0b/03/a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237/aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/ba/fa/3ae643cd525cf6844d3dc810481e5748107368eb49563c15a5fb9f680750/aiohttp-3.13.1.tar.gz"
    sha256 "4b7ee9c355015813a6aa085170b96ec22315dabc3d866fd77d147927000e9464"
  end

  resource "aiohttp-client-cache" do
    url "https://files.pythonhosted.org/packages/7f/5d/f57bab0b5e4854f8cbd323f4b09c84cd1767ed00836af6d62d0445e32242/aiohttp_client_cache-0.14.1.tar.gz"
    sha256 "af5556f719814aca02db6384271069cec6a67be31a6b7d9437e0a6a9980a494f"
  end

  resource "aiohttp-retry" do
    url "https://files.pythonhosted.org/packages/9d/61/ebda4d8e3d8cfa1fd3db0fb428db2dd7461d5742cea35178277ad180b033/aiohttp_retry-2.9.1.tar.gz"
    sha256 "8eb75e904ed4ee5c2ec242fefe85bf04240f685391c4879d8f541d6028ff01f1"
  end

  resource "aioshutil" do
    url "https://files.pythonhosted.org/packages/75/e4/ef86f1777a9bc0c51d50487b471644ae20941afe503591d3a4c86e456dac/aioshutil-1.5.tar.gz"
    sha256 "2756d6cd3bb03405dc7348ac11a0b60eb949ebd63cdd15f56e922410231c1201"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "aiosqlite" do
    url "https://files.pythonhosted.org/packages/13/7d/8bca2bf9a247c2c5dfeec1d7a5f40db6518f88d314b8bca9da29670d2671/aiosqlite-0.21.0.tar.gz"
    sha256 "131bb8056daa3bc875608c631c678cda73922a2d4ba8aec373b19f18c17e7aa3"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/c6/78/7d432127c41b50bccba979505f272c16cbcadcc33645d5fa3a738110ae75/anyio-4.11.0.tar.gz"
    sha256 "82a8d0b81e318cc5ce71a5f1f8b5c4e63619620b63141ef8c995fa0db95a57c4"
  end

  resource "asyncer" do
    url "https://files.pythonhosted.org/packages/6b/41/71af52c036f3e38f3d90f50efd0bc5175b2283d32b2e8a3da11b4b0db84a/asyncer-0.0.10.tar.gz"
    sha256 "8ae3e569d4c0af2882be0822f848adf59712cc52aa5da6ead53473869c90d98e"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/6b/5c/685e6633917e101e5dcb62b9dd76946cbb57c26e133bae9e0cd36033c0a9/attrs-25.4.0.tar.gz"
    sha256 "16d5969b87f0859ef33a48b35d55ac1be6e42ae49d5e853b597db70c35c57e11"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "chevron" do
    url "https://files.pythonhosted.org/packages/15/1f/ca74b65b19798895d63a6e92874162f44233467c9e7c1ed8afd19016ebe9/chevron-0.14.0.tar.gz"
    sha256 "87613aafdf6d77b6a90ff073165a61ae5086e21ad49057aa0e53681601800ebf"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/46/61/de6cd827efad202d7057d93e0fed9294b96952e188f7384832791c7b2254/click-8.3.0.tar.gz"
    sha256 "e7b8232224eba16f4ebe410c25ced9f7875cb5f3263ffc93cc3e8da705e229c4"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/72/94/63b0fc47eb32792c7ba1fe1b694daec9a63620db1e313033d18140c2320a/gitdb-4.0.12.tar.gz"
    sha256 "5ef71f855d191a3326fcfbc0d5da835f26b13fbcba60c32c21091c349ffdb571"
  end

  resource "gitpython" do
    url "https://files.pythonhosted.org/packages/9a/c8/dd58967d119baab745caec2f9d853297cec1989ec1d63f677d3880632b88/gitpython-3.1.45.tar.gz"
    sha256 "85b0ee964ceddf211c41b9f27a49086010a190fd8132a24e21f362a4b36a791c"
  end

  resource "greenlet" do
    url "https://files.pythonhosted.org/packages/c9/92/bb85bd6e80148a4d2e0c59f7c0c2891029f8fd510183afc7d8d2feeed9b6/greenlet-3.2.3.tar.gz"
    sha256 "8b0dd8ae4c0d6f5e54ee55ba935eeb3d735a9b58a8a1e5b5cbab64e01a39f365"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/cf/8c/f834fbf984f691b4f7ff60f50b514cc3de5cc08abfc3295564dd89c5e2e7/importlib_resources-6.5.2.tar.gz"
    sha256 "185f87adef5bcc288449d98fb4fba07cea78bc036455dd44c5fc4a2fe78fed2c"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/9c/cb/8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31d/itsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "jsonata-python" do
    url "https://files.pythonhosted.org/packages/74/c7/f7424658f7c20266d29343d9fc2cc764a0f83460ee61a8f84b591d161450/jsonata_python-0.6.0.tar.gz"
    sha256 "2f605ec016eec13ab009de00631b9bb7b6a4bf7918cfcbe7f7f393cfdc550009"
  end

  resource "jsonbender" do
    url "https://files.pythonhosted.org/packages/33/ba/b89ab7fb6127eda78e6351568a80cb1e45c5c2c87c3e96df6e6e5a922b43/JSONBender-0.9.3.tar.gz"
    sha256 "54c0503f9e2f9768b113c12ef3d9502da14f0c434853a515cbc9c20e21572538"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/74/69/f7185de793a29082a9f3c7728268ffb31cb5095131a9c139a74078e27336/jsonschema-4.25.1.tar.gz"
    sha256 "e4a9655ce0da0c0b67a085847e00a3a51449e1157f4f75e9fb5aa545e122eb85"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/19/74/a633ee74eb36c44aa6d1095e7cc5569bebf04342ee146178e2d36600708b/jsonschema_specifications-2025.9.1.tar.gz"
    sha256 "b540987f239e745613c7a9176f3edb72b832a4ac465cf02712288397832b5e8d"
  end

  resource "jwt" do
    url "https://files.pythonhosted.org/packages/7f/20/21254c9e601e6c29445d1e8854c2a81bdb554e07a82fb1f9846137a6965c/jwt-1.4.0.tar.gz"
    sha256 "f6f789128ac247142c79ee10f3dba6e366ec4e77c9920d18c1592e28aa0a7952"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "mintotp" do
    url "https://files.pythonhosted.org/packages/c0/b4/126c898d8bdd6d73ee702cf221ab8ddfb8c53db9bc101272542e478eba20/mintotp-0.3.0.tar.gz"
    sha256 "d0f4db5edb38a7481120176a526e8c29539b9e80581dd2dcc1811557d77cfad5"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/80/1e/5492c365f222f907de1039b91f922b93fa4f764c713ee858d235495d8f50/multidict-6.7.0.tar.gz"
    sha256 "c6e99d9a65ca282e578dfea819cfa9c0a62b2499d8677392e09feaf305e9e6f5"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/9e/da/e9fc233cf63743258bff22b3dfa7ea5baef7b5bc324af47a0ad89b8ffc6f/propcache-0.4.1.tar.gz"
    sha256 "f48107a8c637e80362555f37ecf49abe20370e557cc4ab374f04ec4423c97c3d"
  end

  resource "pyee" do
    url "https://files.pythonhosted.org/packages/95/03/1fd98d5841cd7964a27d729ccf2199602fe05eb7a405c1462eb7277945ed/pyee-13.0.0.tar.gz"
    sha256 "b391e3c5a434d1f5118a25615001dbc8f669cf410ab67d04c4d4e07c55481c37"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/06/c6/a3124dee667a423f2c637cfd262a54d67d8ccf3e160f3c50f622a85b7723/pynacl-1.6.0.tar.gz"
    sha256 "cb36deafe6e2bce3b286e5d1f3e1c246e0ccdb8808ddb4550bb2792f2df298f2"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/22/f5/df4e9027acead3ecc63e50fe1e36aca1523e1719559c499951bb4b53188f/referencing-0.37.0.tar.gz"
    sha256 "44aefc3142c5b842538163acb373e24cce6632bd54bdb01b21ad5863489f50d8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/ab/3a/0316b28d0761c6734d6bc14e770d85506c986c85ffb239e688eeaab2c2bc/rich-13.9.4.tar.gz"
    sha256 "439594978a49a09530cff7ebc4b5c7103ef57baf48d5ea3184f21d9a2befa098"
  end

  resource "rjsonnet" do
    url "https://files.pythonhosted.org/packages/70/65/4c6b1e4baf48ebbc6ff0c8cf8b50f08c63173d9abd5dd7f3af03b4bcd460/rjsonnet-0.5.6.tar.gz"
    sha256 "47bd8f63b4b1def67f83001c07ff7d43d6a90dbf89cb6fb680c941db809a60ce"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/44/cd/a040c4b3119bbe532e5b0732286f805445375489fceaec1f48306068ee3b/smmap-5.0.2.tar.gz"
    sha256 "26ea65a03958fa0c8a1c7e8c7a58fdc77221b8910f6be2131affade476898ad5"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "url-normalize" do
    url "https://files.pythonhosted.org/packages/80/31/febb777441e5fcdaacb4522316bf2a527c44551430a4873b052d545e3279/url_normalize-2.2.1.tar.gz"
    sha256 "74a540a3b6eba1d95bdc610c24f2c0141639f3ba903501e61a52a8730247ff37"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/57/63/0c6ebca57330cd313f6102b16dd57ffaf3ec4c83403dcb45dbd15c6f3ea1/yarl-1.22.0.tar.gz"
    sha256 "bebf8557577d4401ba8bd9ff33906f1376c877aa78d1fe216ad01b4d6745af71"
  end

  def install
    # hatch does not support a SOURCE_DATE_EPOCH before 1980.
    # Remove after https://github.com/pypa/hatch/pull/1999 is released.
    ENV["SOURCE_DATE_EPOCH"] = "1451574000"
    ENV["SETUPTOOLS_SCM_PRETEND_VERSION_FOR_PLAYWRIGHT"] = resource("playwright").version
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"otterdog", shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/otterdog --version")

    assert_match "File 'otterdog.json' does not exist", shell_output("#{bin}/otterdog validate 2>&1", 2)
  end
end