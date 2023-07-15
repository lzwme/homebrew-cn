class Jupyterlab < Formula
  include Language::Python::Virtualenv

  desc "Interactive environments for writing and running code"
  homepage "https://jupyter.org/"
  url "https://files.pythonhosted.org/packages/83/a6/1f518719e924189d56e77cd02dde0675a0473f3c5b5e8c7294b2bbaf9c49/jupyterlab-4.0.3.tar.gz"
  sha256 "e14d1ce46a613028111d0d476a1d7d6b094003b7462bac669f5b478317abcb39"
  license all_of: [
    "BSD-3-Clause",
    "MIT", # semver.py
  ]

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1da2e1a5978f4c058bafdfb086d7f4cc94f186ebda650475cb60d5ca1645b3cd"
    sha256 cellar: :any,                 arm64_monterey: "6852e0964cf4682d37d610458ba195c5b47dd3474e00670862a870131f52dccd"
    sha256 cellar: :any,                 arm64_big_sur:  "af91d23f8aedcd6d815735b968cb594bcdb52ada68cdbfaa90ab516caf19c65b"
    sha256 cellar: :any,                 ventura:        "c1f7cf1827532ea387fc115c105766c38ffe79375354f173852cabcdca6f2736"
    sha256 cellar: :any,                 monterey:       "c37720dbd34e47b8af97fcb6de6d042538996a620bf7404ac1f8432ae3556bfd"
    sha256 cellar: :any,                 big_sur:        "cfe808bda6e85321fd01a97553c245d9db19dda5939b5cb687f3a02af24f0b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fc1617de7cc3763570467f48a97aece82888bb0b8cd9ba4426c35ece859c809"
  end

  depends_on "hatch" => :build
  depends_on "python-build" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "ipython"
  depends_on "node"
  depends_on "pandoc"
  depends_on "pycparser"
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"
  depends_on "zeromq"

  uses_from_macos "expect" => :test
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/28/99/2dfd53fd55ce9838e6ff2d4dac20ce58263798bd1a0dbe18b3a9af3fcfce/anyio-3.7.1.tar.gz"
    sha256 "44a3c9aba0f5defa43261a8b3efb97891f2bd7d804e0e1f56419befa1adfc780"
  end

  resource "argon2-cffi" do
    url "https://files.pythonhosted.org/packages/3f/18/20bb5b6bf55e55d14558b57afc3d4476349ab90e0c43e60f27a7c2187289/argon2-cffi-21.3.0.tar.gz"
    sha256 "d384164d944190a7dd7ef22c6aa3ff197da12962bd04b17f64d4e93d934dba5b"
  end

  resource "argon2-cffi-bindings" do
    url "https://files.pythonhosted.org/packages/b9/e9/184b8ccce6683b0aa2fbb7ba5683ea4b9c5763f1356347f1312c32e3c66e/argon2-cffi-bindings-21.2.0.tar.gz"
    sha256 "bb89ceffa6c791807d1305ceb77dbfacc5aa499891d2c55661c6459651fc39e3"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "async-lru" do
    url "https://files.pythonhosted.org/packages/10/10/c2f791f7b14652a02d9cf1a11808a27053511681bbb432d6901d7dc9dae6/async-lru-2.0.3.tar.gz"
    sha256 "b714c9d1415fca4e264da72a9e2abc66880ce7430e03a973341f88ea4c0d4869"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "babel" do
    url "https://files.pythonhosted.org/packages/ba/42/54426ba5d7aeebde9f4aaba9884596eb2fe02b413ad77d62ef0b0422e205/Babel-2.12.1.tar.gz"
    sha256 "cc2d99999cd01d44420ae725a21c9e3711b3aadc7976d6147f622d8581963455"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/af/0b/44c39cf3b18a9280950ad63a579ce395dda4c32193ee9da7ff0aed547094/beautifulsoup4-4.12.2.tar.gz"
    sha256 "492bbc69dca35d12daac71c4db1bfff0c876c00ef4a2ffacce226d4638eb72da"
  end

  resource "bleach" do
    url "https://files.pythonhosted.org/packages/7e/e6/d5f220ca638f6a25557a611860482cb6e54b2d97f0332966b1b005742e1f/bleach-6.0.0.tar.gz"
    sha256 "1a1a85c1595e07d8db14c5f09f09e6433502c51c595970edc090551f0db99414"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "comm" do
    url "https://files.pythonhosted.org/packages/d6/1a/9937a10f8fd6d9f0f72fa0ab520cec7e50c534b215f8fd2d28e0f0a7f9a7/comm-0.1.3.tar.gz"
    sha256 "a61efa9daffcfbe66fd643ba966f846a624e4e6d6767eda9cf6e993aadaab93e"
  end

  resource "debugpy" do
    url "https://files.pythonhosted.org/packages/92/d4/437fa53a5a0e5a04d77e12b7eeac1df003e33834f85ddd4513fe2df31e13/debugpy-1.6.7.zip"
    sha256 "c4c2f0810fa25323abfdfa36cbbbb24e5c3b1a42cb762782de64439c575d67f2"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "fastjsonschema" do
    url "https://files.pythonhosted.org/packages/a4/e1/cda97fa4447e138f1f0ccfdaf678fa247415f7e9f4942d856fd63c7d863c/fastjsonschema-2.17.1.tar.gz"
    sha256 "f4eeb8a77cef54861dbf7424ac8ce71306f12cbb086c45131bcba2c6a4f726e3"
  end

  resource "fqdn" do
    url "https://files.pythonhosted.org/packages/30/3e/a80a8c077fd798951169626cde3e239adeba7dab75deb3555716415bd9b0/fqdn-1.5.1.tar.gz"
    sha256 "105ed3677e767fb5ca086a0c1f4bb66ebc3c100be518f0e0d755d9eae164d89f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "ipykernel" do
    url "https://files.pythonhosted.org/packages/13/1e/28209323ee0be7e1afa0e4029f739d184c4b0c1c35ee557dadccb7cf1ae9/ipykernel-6.24.0.tar.gz"
    sha256 "29cea0a716b1176d002a61d0b0c851f34536495bc4ef7dd0222c88b41b816123"
  end

  resource "ipython-genutils" do
    url "https://files.pythonhosted.org/packages/e8/69/fbeffffc05236398ebfcfb512b6d2511c622871dca1746361006da310399/ipython_genutils-0.2.0.tar.gz"
    sha256 "eb2e116e75ecef9d4d228fdc66af54269afa26ab4463042e33785b887c628ba8"
  end

  resource "isoduration" do
    url "https://files.pythonhosted.org/packages/7c/1a/3c8edc664e06e6bd06cce40c6b22da5f1429aa4224d0c590f3be21c91ead/isoduration-20.11.0.tar.gz"
    sha256 "ac2f9015137935279eac671f94f89eb00584f940f5dc49462a0c4ee692ba1bd9"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "json5" do
    url "https://files.pythonhosted.org/packages/f9/40/89e0ecbf8180e112f22046553b50a99fdbb9e8b7c49d547cda2bfa81097b/json5-0.9.14.tar.gz"
    sha256 "9ed66c3a6ca3510a976a9ef9b8c0787de24802724ab1860bc0153c7fdd589b02"
  end

  resource "jsonpointer" do
    url "https://files.pythonhosted.org/packages/8f/5e/67d3ab449818b629a0ffe554bb7eb5c030a71f7af5d80fbf670d7ebe62bc/jsonpointer-2.4.tar.gz"
    sha256 "585cee82b70211fa9e6043b7bb89db6e1aa49524340dde8ad6b63206ea689d88"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/7e/6b/38c38d113b5f215029cbe8133e7f907540fefa918d872fa3256416e477bf/jsonschema-4.18.3.tar.gz"
    sha256 "64b7104d72efe856bea49ca4af37a14a9eba31b40bb7238179f3803130fd34d9"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/9a/8c/3d028449ac15cba52db3e1c95ca53b9240b4707fbe17f43e01cc73dd9336/jsonschema_specifications-2023.6.1.tar.gz"
    sha256 "ca1c4dd059a9e7b34101cf5b3ab7ff1d18b139f35950d598d629837ef66e8f28"
  end

  resource "jupyter-client" do
    url "https://files.pythonhosted.org/packages/f9/bb/454464291217af5dc1d0dfc636f7f6b68227758319dad5f64b341ffd54f5/jupyter_client-8.3.0.tar.gz"
    sha256 "3af69921fe99617be1670399a0b857ad67275eefcfa291e2c81a160b7b650f5f"
  end

  resource "jupyter-console" do
    url "https://files.pythonhosted.org/packages/bd/2d/e2fd31e2fc41c14e2bcb6c976ab732597e907523f6b2420305f9fc7fdbdb/jupyter_console-6.6.3.tar.gz"
    sha256 "566a4bf31c87adbfadf22cdf846e3069b59a71ed5da71d6ba4d8aaad14a53539"
  end

  resource "jupyter-core" do
    url "https://files.pythonhosted.org/packages/9e/53/f27bd74ceaa672a1ce17b4b2bee93c0742ca00cb9f540ec4fa60cf7319b5/jupyter_core-5.3.1.tar.gz"
    sha256 "5ba5c7938a7f97a6b0481463f7ff0dbac7c15ba48cf46fa4035ca6e838aa1aba"
  end

  resource "jupyter-events" do
    url "https://files.pythonhosted.org/packages/d0/b0/7afcd1d66834f43d08ec47c861a5540d7ad57eab47605ccd83429c147755/jupyter_events-0.6.3.tar.gz"
    sha256 "9a6e9995f75d1b7146b436ea24d696ce3a35bfa8bfe45e0c33c334c79464d0b3"
  end

  resource "jupyter-lsp" do
    url "https://files.pythonhosted.org/packages/01/f9/85c8361175208e279f63c3896db14b547d821c9cb8a52675e51a7bdb336f/jupyter-lsp-2.2.0.tar.gz"
    sha256 "8ebbcb533adb41e5d635eb8fe82956b0aafbf0fd443b6c4bfa906edeeb8635a1"
  end

  resource "jupyter-server" do
    url "https://files.pythonhosted.org/packages/2b/82/f4a31af1a03b1f9fa9fe60bb3713bfb1032500ff9c0704a31688ae40ae66/jupyter_server-2.7.0.tar.gz"
    sha256 "36da0a266d31a41ac335a366c88933c17dfa5bb817a48f5c02c16d303bc9477f"
  end

  resource "jupyter-server-terminals" do
    url "https://files.pythonhosted.org/packages/54/e1/6bc19392e6957356f085b8d7ec33d6d0d721e646b7576c1c6758dd264c64/jupyter_server_terminals-0.4.4.tar.gz"
    sha256 "57ab779797c25a7ba68e97bcfb5d7740f2b5e8a83b5e8102b10438041a7eac5d"
  end

  resource "jupyterlab-pygments" do
    url "https://files.pythonhosted.org/packages/69/8e/8ae01f052013ee578b297499d16fcfafb892927d8e41c1a0054d2f99a569/jupyterlab_pygments-0.2.2.tar.gz"
    sha256 "7405d7fde60819d905a9fa8ce89e4cd830e318cdad22a0030f7a901da705585d"
  end

  resource "jupyterlab-server" do
    url "https://files.pythonhosted.org/packages/02/65/f7ba44dc74f611b1d00fb37ed1ad0069edeb353a0f0cc7214e3014575b85/jupyterlab_server-2.23.0.tar.gz"
    sha256 "83c01aa4ad9451cd61b383e634d939ff713850f4640c0056b2cdb2b6211a74c7"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  resource "mistune" do
    url "https://files.pythonhosted.org/packages/0c/88/6862147c3203750cef135070fe9f841d82146c4206f55239592bcc27b0cd/mistune-3.0.1.tar.gz"
    sha256 "e912116c13aa0944f9dc530db38eb88f6a77087ab128f49f84a48f4c05ea163c"
  end

  resource "nbclassic" do
    url "https://files.pythonhosted.org/packages/8b/11/6e6084bad2b2f8faa787bd5f72fd1171c741801a03872b518965d7653ba5/nbclassic-1.0.0.tar.gz"
    sha256 "0ae11eb2319455d805596bf320336cda9554b41d99ab9a3c31bf8180bffa30e3"
  end

  resource "nbclient" do
    url "https://files.pythonhosted.org/packages/4c/09/ca367efae271cef775345147c792f6c870d3a6ed5c410795c9754e710248/nbclient-0.8.0.tar.gz"
    sha256 "f9b179cd4b2d7bca965f900a2ebf0db4a12ebff2f36a711cb66861e4ae158e55"
  end

  resource "nbconvert" do
    url "https://files.pythonhosted.org/packages/e7/0b/b214dd940274564cc610d6c66d98750ca0e8d59281f300451654f4542284/nbconvert-7.6.0.tar.gz"
    sha256 "24fcf27efdef2b51d7f090cc5ce5a9b178766a55be513c4ebab08c91899ab550"
  end

  resource "nbformat" do
    url "https://files.pythonhosted.org/packages/80/3e/392d1ab3196574ba6818874ec50d419bced99e7fde8b58c77b803675d8bf/nbformat-5.9.1.tar.gz"
    sha256 "3a7f52d040639cbd8a3890218c8b0ffb93211588c57446c90095e32ba5881b5d"
  end

  resource "nest-asyncio" do
    url "https://files.pythonhosted.org/packages/35/76/64c51c1cbe704ad79ef6ec82f232d1893b9365f2ff194111787dc91b004f/nest_asyncio-1.5.6.tar.gz"
    sha256 "d267cc1ff794403f7df692964d1d2a3fa9418ffea2a3f6859a439ff482fef290"
  end

  resource "notebook" do
    url "https://files.pythonhosted.org/packages/52/1e/b555b6e33c962a605e2e85b6014f609d3e1c6a5ff48f7c2480376b430d96/notebook-6.5.4.tar.gz"
    sha256 "517209568bd47261e2def27a140e97d49070602eea0d226a696f42a7f16c9a4e"
    # This is to avoid a circular dependency, where `notebook` depends on `nbclassic`,
    # which transitively depends on `notebook`.
    patch :DATA
  end

  resource "notebook-shim" do
    url "https://files.pythonhosted.org/packages/ea/10/6c6c7adc0d61e72cfc4055d0671bbd12bdc6ffea86892e903bd2398b9019/notebook_shim-0.2.3.tar.gz"
    sha256 "f69388ac283ae008cd506dda10d0288b09a017d822d5e8c7129a152cbd3ce7e9"
  end

  resource "overrides" do
    url "https://files.pythonhosted.org/packages/f6/39/e2e3c2c7eba7793a01b5f592c3c7fd6b27da53d75de81430407ef18befb7/overrides-7.3.1.tar.gz"
    sha256 "8b97c6c1e1681b78cbc9424b138d880f0803c2254c5ebaabdde57bb6c62093f2"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pandocfilters" do
    url "https://files.pythonhosted.org/packages/62/42/c32476b110a2d25277be875b82b5669f2cdda7897c165bd22b78f366b3cb/pandocfilters-1.5.0.tar.gz"
    sha256 "0b679503337d233b4339a817bfc8c50064e2eff681314376a47cb582305a7a38"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/92/38/3dd18a282991c004851ea1f0953105a186cfc691eee2792778ac2ca060f8/platformdirs-3.8.1.tar.gz"
    sha256 "f87ca4fcff7d2b0f81c6a748a77973d7af0f4d526f98f308477c3c436c74d528"
  end

  resource "prometheus-client" do
    url "https://files.pythonhosted.org/packages/f5/05/aee33352594522c56eb4a4382b5acd9a706a030db9ba2fc3dc38a283e75c/prometheus_client-0.17.1.tar.gz"
    sha256 "21e674f39831ae3f8acde238afd9a27a37d0d2fb5a28ea094f0ce25d2cbf2091"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/4f/da/95963cebfc578dabd323d7263958dfb68898617912bb09327dd30e9c8d13/python-json-logger-2.0.7.tar.gz"
    sha256 "23e7ec02d34237c5aa1e29a070193a4ea87583bb4e7f8fd06d3de8264c4b2e1c"
  end

  resource "pyzmq" do
    url "https://files.pythonhosted.org/packages/64/9c/2b2614b0b86ff703b3a33ea5e044923bd7d100adc8c829d579a9b71ea9e7/pyzmq-25.1.0.tar.gz"
    sha256 "80c41023465d36280e801564a69cbfce8ae85ff79b080e1913f6e90481fb8957"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/20/93/45213b5b6e3eeab03e3f6eb82cc516a81fbf257586a25f9eb1d21af96e1b/referencing-0.29.1.tar.gz"
    sha256 "90cb53782d550ba28d2166ef3f55731f38397def8832baac5d45235f1995e35e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rfc3339-validator" do
    url "https://files.pythonhosted.org/packages/28/ea/a9387748e2d111c3c2b275ba970b735e04e15cdb1eb30693b6b5708c4dbd/rfc3339_validator-0.1.4.tar.gz"
    sha256 "138a2abdf93304ad60530167e51d2dfb9549521a836871b88d7f4695d0022f6b"
  end

  resource "rfc3986-validator" do
    url "https://files.pythonhosted.org/packages/da/88/f270de456dd7d11dcc808abfa291ecdd3f45ff44e3b549ffa01b126464d0/rfc3986_validator-0.1.1.tar.gz"
    sha256 "3d44bde7921b3b9ec3ae4e3adca370438eccebc676456449b145d533b240d055"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/e6/fe/7d07bc08cce2ccae2c7e5c96d9b3976c4e1fa5e248989dca0a58bc7628f8/rpds_py-0.8.10.tar.gz"
    sha256 "13e643ce8ad502a0263397362fb887594b49cf84bf518d6038c16f235f2bcea4"
  end

  resource "send2trash" do
    url "https://files.pythonhosted.org/packages/4a/d2/d4b4d8b1564752b4e593c6d007426172b6574df5a7c07322feba010f5551/Send2Trash-1.8.2.tar.gz"
    sha256 "c132d59fa44b9ca2b1699af5c86f57ce9f4c5eb56629d5d55fbb7a35f84e2312"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/cd/50/d49c388cae4ec10e8109b1b833fd265511840706808576df3ada99ecb0ac/sniffio-1.3.0.tar.gz"
    sha256 "e60305c5e5d314f5389259b7f22aaa33d8f7dee49763119234af3755c55b9101"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/47/9e/780779233a615777fbdf75a4dee2af7a345f4bf74b42d4a5f836800b9d91/soupsieve-2.4.1.tar.gz"
    sha256 "89d12b2d5dfcd2c9e8c22326da9d9aa9cb3dfab0a83a024f05704076ee8d35ea"
  end

  resource "terminado" do
    url "https://files.pythonhosted.org/packages/55/be/748034192602b9fd69ba94544c1675ff18b039ed8f346ad783478e31144f/terminado-0.17.1.tar.gz"
    sha256 "6ccbbcd3a4f8a25a5ec04991f39a0b8db52dfcd487ea0e578d977e6752380333"
  end

  resource "tinycss2" do
    url "https://files.pythonhosted.org/packages/75/be/24179dfaa1d742c9365cbd0e3f0edc5d3aa3abad415a2327c5a6ff8ca077/tinycss2-1.2.1.tar.gz"
    sha256 "8cff3a8f066c2ec677c06dbc7b45619804a6938478d9d73c284b29d14ecb0627"
  end

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/30/f0/6e5d85d422a26fd696a1f2613ab8119495c1ebb8f49e29f428d15daf79cc/tornado-6.3.2.tar.gz"
    sha256 "4b927c4f19b71e627b13f3db2324e4ae660527143f9e1f2e2fb404f3a187e2ba"
  end

  resource "uri-template" do
    url "https://files.pythonhosted.org/packages/31/c7/0336f2bd0bcbada6ccef7aaa25e443c118a704f828a0620c6fa0207c1b64/uri-template-1.3.0.tar.gz"
    sha256 "0e00f8eb65e18c7de20d595a14336e9f337ead580c70934141624b6d1ffdacc7"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  resource "webcolors" do
    url "https://files.pythonhosted.org/packages/a1/fb/f95560c6a5d4469d9c49e24cf1b5d4d21ffab5608251c6020a965fb7791c/webcolors-1.13.tar.gz"
    sha256 "c225b674c83fa923be93d235330ce0300373d02885cef23238813b0d5668304a"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/b1/34/3a5cae1e07d9566ad073fa6d169bf22c03a3ba7b31b3c3422ec88d039108/websocket-client-1.6.1.tar.gz"
    sha256 "c951af98631d24f8df89ab1019fc365f2227c0892f12fd150e935607c79dd0dd"
  end

  def python3
    "python3.11"
  end

  def install
    venv = virtualenv_create(libexec, python3)
    ENV["JUPYTER_PATH"] = etc/"jupyter"

    site_packages = Language::Python.site_packages(python3)
    %w[ipython].each do |package_name|
      package = Formula[package_name].opt_libexec
      (libexec/site_packages/"homebrew-#{package_name}.pth").write package/site_packages
    end

    preinstall = %w[jupyterlab-pygments nbclassic]
    linked_hatch = %w[
      jupyter-core jupyter-client jupyter-events jupyter-server jupyter-server-terminals
      nbformat ipykernel nbconvert
    ]
    linked_setuptools = %w[jupyter-console]
    unlinked_hatch = %w[jupyterlab-server]
    unlinked_setuptools = (
      resources.to_set(&:name) - preinstall - linked_hatch - linked_setuptools - unlinked_hatch
    )

    pybuild = Formula["python-build"].opt_bin/"pyproject-build"
    hatch = Formula["hatch"].opt_bin/"hatch"

    # The "preinstall" dependencies require `jupyterlab` to build. Since Homebrew doesn't
    # allow circular dependencies, we locally build wheels for these dependencies
    # using the pre-built PyPI wheels for `jupyterlab` and its dependencies.
    preinstall.each do |r|
      resource(r).stage do
        system pybuild, "--wheel"
        venv.pip_install Dir["dist/*.whl"].first
      end
    end

    # install remaining packages into virtualenv and link specified packages
    unlinked_setuptools.each do |r|
      venv.pip_install resource(r)
    end
    unlinked_hatch.each do |r|
      resource(r).stage do
        system hatch, "build", "-t", "wheel"
        venv.pip_install Dir["dist/*.whl"].first
      end
    end
    linked_setuptools.each do |r|
      venv.pip_install_and_link resource(r)
    end
    linked_hatch.each do |r|
      resource(r).stage do
        system hatch, "build", "-t", "wheel"
        venv.pip_install_and_link Dir["dist/*.whl"].first
      end
    end

    venv.pip_install_and_link buildpath

    # remove bundled kernel
    (libexec/"share/jupyter/kernels").rmtree

    # install completion
    resource("jupyter-core").stage do
      bash_completion.install "examples/jupyter-completion.bash" => "jupyter"
      zsh_completion.install "examples/completions-zsh" => "_jupyter"
    end
  end

  def caveats
    <<~EOS
      Additional kernels can be installed into the shared jupyter directory
        #{etc}/jupyter
    EOS
  end

  test do
    system bin/"jupyter-console --help"
    assert_match python3, shell_output("#{bin}/jupyter kernelspec list")

    (testpath/"console.exp").write <<~EOS
      spawn #{bin}/jupyter-console
      expect "In "
      send "exit\r"
    EOS
    assert_match "Jupyter console", shell_output("expect -f console.exp")

    (testpath/"notebook.exp").write <<~EOS
      spawn #{bin}/jupyter notebook --no-browser
      expect "NotebookApp"
    EOS
    assert_match "NotebookApp", shell_output("expect -f notebook.exp")

    (testpath/"nbconvert.ipynb").write <<~EOS
      {
        "cells": []
      }
    EOS
    system bin/"jupyter-nbconvert", "nbconvert.ipynb", "--to", "html"
    assert_predicate testpath/"nbconvert.html", :exist?, "Failed to export HTML"

    assert_match "-F _jupyter",
      shell_output("bash -c \"source #{bash_completion}/jupyter && complete -p jupyter\"")

    # Ensure that jupyter can load the jupyter lab package.
    assert_match(/^jupyterlab *: #{version}$/,
      shell_output(bin/"jupyter --version"))

    # Ensure that jupyter-lab binary was installed by pip.
    assert_equal version.to_s,
      shell_output(bin/"jupyter-lab --version").strip

    port = free_port
    fork { exec "#{bin}/jupyter-lab", "-y", "--port=#{port}", "--no-browser", "--ip=127.0.0.1", "--LabApp.token=''" }
    sleep 10
    assert_match "<title>JupyterLab</title>",
      shell_output("curl --silent --fail http://localhost:#{port}/lab")
  end
end

__END__
--- a/pyproject.toml	2023-01-27 12:04:48
+++ b/pyproject.toml	2023-01-27 12:05:01
@@ -1,5 +1,5 @@
 [build-system]
-requires=["jupyter_packaging~=0.9", "nbclassic>=0.4.0"]
+requires=["jupyter_packaging~=0.9"]
 build-backend = "setuptools.build_meta"

 [tool.check-manifest]