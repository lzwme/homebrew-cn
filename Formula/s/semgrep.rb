class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https:semgrep.dev"
  url "https:github.comsemgrepsemgrep.git",
      tag:      "v1.82.0",
      revision: "992e4820e315854d89d16cc064c0ac753c858ca3"
  license "LGPL-2.1-only"
  head "https:github.comsemgrepsemgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7b20e9c290e8e58b6af19bd1c1d569d047b926b5d51b3ea8b34d7efa3050e799"
    sha256 cellar: :any,                 arm64_ventura:  "4059a42336f3d9045c9422cf418cfea10104d5bf0fa9eaf06e6bb0a36b7d3d01"
    sha256 cellar: :any,                 arm64_monterey: "09e75076f4a3ad8969454e2b5a54ab54692162bbfe7ef31c4a34d67052f80973"
    sha256 cellar: :any,                 sonoma:         "b5674e8d2395999ef97752027d6289ffe471c20b5617373250bab77e9cbb554f"
    sha256 cellar: :any,                 ventura:        "1be8f44716b7f9c266cf5ef83b26d9f877318056054834c267628a7e432a7a86"
    sha256 cellar: :any,                 monterey:       "aa2acd9cc010cfdc217085139fbc8bf1e37931ca75aafec99ef6a710b87400f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "665536715fcf92eb6b6d793dcf347da1c286d5d645ec11d1591a7ebaf8047b30"
  end

  depends_on "autoconf" => :build
  depends_on "cmake" => :build
  depends_on "coreutils"=> :build
  depends_on "dune" => :build
  depends_on "ocaml" => :build
  depends_on "opam" => :build
  depends_on "pipenv" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "gmp"
  depends_on "libev"
  depends_on "pcre"
  depends_on "pcre2"
  depends_on "python@3.12"
  depends_on "sqlite"
  depends_on "tree-sitter"

  uses_from_macos "rsync" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  resource "attrs" do
    url "https:files.pythonhosted.orgpackagese3fcf800d51204003fa8ae392c4e8278f256206e7a919b708eef054f5f4b650dattrs-23.2.0.tar.gz"
    sha256 "935dc3b529c262f6cf76e50877d35a4bd3c1de194fd41f47a2b7ae8f19971f30"
  end

  resource "boltons" do
    url "https:files.pythonhosted.orgpackagesad1f6c0608d86e0fc77c982a2923ece80eef85f091f2332fc13cbce41d70d502boltons-21.0.0.tar.gz"
    sha256 "65e70a79a731a7fe6e98592ecfb5ccf2115873d01dbc576079874629e5c90f13"
  end

  resource "bracex" do
    url "https:files.pythonhosted.orgpackages908b34d174ce519f859af104c722fa30213103d34896a07a4f27bde6ac780633bracex-2.4.tar.gz"
    sha256 "a27eaf1df42cf561fed58b7a8f3fdf129d1ea16a81e1fadd1d17989bc6384beb"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-option-group" do
    url "https:files.pythonhosted.orgpackagese7b891054601a2e05fd9060cb1baf56be5b24145817b059e078669e1099529c7click-option-group-0.5.6.tar.gz"
    sha256 "97d06703873518cc5038509443742b25069a3c7562d1ea72ff08bfadde1ce777"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "defusedxml" do
    url "https:files.pythonhosted.orgpackages0fd5c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "deprecated" do
    url "https:files.pythonhosted.orgpackages92141e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "exceptiongroup" do
    url "https:files.pythonhosted.orgpackages09352495c4ac46b980e4ca1f6ad6db102322ef3ad2410b79fdde159a4b0f3b92exceptiongroup-1.2.2.tar.gz"
    sha256 "47c2edf7c6738fafb49fd34290706d1a1a2f4d1c6df275526b62cbb4aa5393cc"
  end

  resource "face" do
    url "https:files.pythonhosted.orgpackagesd7bc4d0f6c1e095eb977782edd94245f84b69c6f8df152480c78ab310e895098face-22.0.0.tar.gz"
    sha256 "d5d692f90bc8f5987b636e47e36384b9bbda499aaf0a77aa0b0bbe834c76923d"
  end

  resource "glom" do
    url "https:files.pythonhosted.orgpackages3fd169432deefa6f5283ec75b246d0540097ae26f618b915519ee3824c4c5dd6glom-22.1.0.tar.gz"
    sha256 "1510c6587a8f9c64a246641b70033cbc5ebde99f02ad245693678038e821aeb5"
  end

  resource "googleapis-common-protos" do
    url "https:files.pythonhosted.orgpackages0b1a41723ae380fa9c561cbe7b61c4eef9091d5fe95486465ccfc84845877331googleapis-common-protos-1.63.2.tar.gz"
    sha256 "27c5abdffc4911f28101e635de1533fb4cfd2c37fbaa9174587c799fac90aa87"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "importlib-metadata" do
    url "https:files.pythonhosted.orgpackagesa0fcc4e6078d21fc4fa56300a241b87eae76766aa380a23fc450fc85bb7bf547importlib_metadata-7.1.0.tar.gz"
    sha256 "b78938b926ee8d5f020fc4772d487045805a55ddbad2ecf21c6d60938dc7fcd2"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages382e03362ee4034a4c917f697890ccd4aec0800ccf9ded7f511971c75451deecjsonschema-4.23.0.tar.gz"
    sha256 "d71497fef26351a33265337fa77ffeb82423f3ea21283cd9467bb03999266bc4"
  end

  resource "jsonschema-specifications" do
    url "https:files.pythonhosted.orgpackagesf8b9cc0cc592e7c195fb8a650c1d5990b10175cf13b4c97465c72ec841de9e4bjsonschema_specifications-2023.12.1.tar.gz"
    sha256 "48a76787b3e70f5ed53f1160d2b81f586e4ca6d1548c5de7085d1682674764cc"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "opentelemetry-api" do
    url "https:files.pythonhosted.orgpackagesdf0d10357006dc10fc65f7c7b46c18232e466e355f9e606ac461cfc7193b4cbeopentelemetry_api-1.25.0.tar.gz"
    sha256 "77c4985f62f2614e42ce77ee4c9da5fa5f0bc1e1821085e9a47533a9323ae869"
  end

  resource "opentelemetry-exporter-otlp-proto-common" do
    url "https:files.pythonhosted.orgpackages37a785ffaaacd712e4634fa1c56cbf79a02cf90b8a178fe1eee2cabfb0b7f44dopentelemetry_exporter_otlp_proto_common-1.25.0.tar.gz"
    sha256 "c93f4e30da4eee02bacd1e004eb82ce4da143a2f8e15b987a9f603e0a85407d3"
  end

  resource "opentelemetry-exporter-otlp-proto-http" do
    url "https:files.pythonhosted.orgpackages72d91c3c518853c27d323a46813d3e99d601959ca2c6963d5217fe2110f0d579opentelemetry_exporter_otlp_proto_http-1.25.0.tar.gz"
    sha256 "9f8723859e37c75183ea7afa73a3542f01d0fd274a5b97487ea24cb683d7d684"
  end

  resource "opentelemetry-instrumentation" do
    url "https:files.pythonhosted.orgpackages0f200a5d980843e048e9516443a91c63a559b40e5d50a730e73e72a5bde727fdopentelemetry_instrumentation-0.46b0.tar.gz"
    sha256 "974e0888fb2a1e01c38fbacc9483d024bb1132aad92d6d24e2e5543887a7adda"
  end

  resource "opentelemetry-instrumentation-requests" do
    url "https:files.pythonhosted.orgpackagesf6285b5e9fb74639e47f026a3fd6550bba965ca18b316a8178907540e711855copentelemetry_instrumentation_requests-0.46b0.tar.gz"
    sha256 "ef0ad63bfd0d52631daaf7d687e763dbd89b465f5cb052f12a4e67e5e3d181e4"
  end

  resource "opentelemetry-proto" do
    url "https:files.pythonhosted.orgpackagesc93c28c9ce40eb8ab287471af81659089ca98ef4f7ce289669e23b19c29f24a8opentelemetry_proto-1.25.0.tar.gz"
    sha256 "35b6ef9dc4a9f7853ecc5006738ad40443701e52c26099e197895cbda8b815a3"
  end

  resource "opentelemetry-sdk" do
    url "https:files.pythonhosted.orgpackages053c77076b77f1d73141adc119f62370ec9456ef314ba0b4e7072e3775c36ef7opentelemetry_sdk-1.25.0.tar.gz"
    sha256 "ce7fc319c57707ef5bf8b74fb9f8ebdb8bfafbe11898410e0d2a761d08a98ec7"
  end

  resource "opentelemetry-semantic-conventions" do
    url "https:files.pythonhosted.orgpackages4eeaa4a5277247b3d2ed2e23a58b0d509c2eafa4ebb56038ba5b23c0f9ea6242opentelemetry_semantic_conventions-0.46b0.tar.gz"
    sha256 "fbc982ecbb6a6e90869b15c1673be90bd18c8a56ff1cffc0864e38e2edffaefa"
  end

  resource "opentelemetry-util-http" do
    url "https:files.pythonhosted.orgpackagesf09145bf243850463b2c83000ca129442255eaef7c446bd0f59a2ab54b15abffopentelemetry_util_http-0.46b0.tar.gz"
    sha256 "03b6e222642f9c7eae58d9132343e045b50aca9761fcb53709bd2b663571fdf6"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "peewee" do
    url "https:files.pythonhosted.orgpackagesbdbee9c886b4601a19f4c34a1b75c5fe8b98a2115dd964251a76b24c977c369dpeewee-3.17.6.tar.gz"
    sha256 "cea5592c6f4da1592b7cff8eaf655be6648a1f5857469e30037bf920c03fb8fb"
  end

  resource "protobuf" do
    url "https:files.pythonhosted.orgpackagese8abcb61a4b87b2e7e6c312dce33602bd5884797fd054e0e53205f1c27cf0f66protobuf-4.25.4.tar.gz"
    sha256 "0dc4a62cc4052a036ee2204d26fe4d835c62827c855c8a03f29fe6da146b380d"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages995b73ca1f8e72fff6fa52119dbd185f73a907b1989428917b24cff660129b6dreferencing-0.35.1.tar.gz"
    sha256 "25b42124a6c8b632a425174f24087783efb348a6f1e0008e63cd4466fedf703c"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages2ffe5217efe981c2ae8647b503ba3b8f55efc837df62f63667572b4bb75b30bcrpds_py-0.19.1.tar.gz"
    sha256 "31dd5794837f00b46f4096aa8ccaa5972f73a938982e32ed817bb520c465e520"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackagesd1d6eb2833ccba5ea36f8f4de4bcfa0d1a91eb618f832d430b70e3086821f251ruamel.yaml-0.17.40.tar.gz"
    sha256 "6024b986f06765d482b5b07e086cc4b4cd05dd22ddcbc758fa23d54873cf313d"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackages5e11487b18cc768e2ae25a919f230417983c8d5afa1b6ee0abd8b6db0b89fa1dsetuptools-72.1.0.tar.gz"
    sha256 "8d243eff56d095e5817f796ede6ae32941278f542e0f941867cc05ae52b162ec"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackagesc03fd7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  resource "wcmatch" do
    url "https:files.pythonhosted.orgpackageseac455e0d36da61d7b8b2a49fd273e6b296fd5e8471c72ebbe438635d1af3968wcmatch-8.5.2.tar.gz"
    sha256 "a70222b86dea82fb382dd87b73278c10756c138bd6f8f714e2183128887b9eb2"
  end

  resource "wrapt" do
    url "https:files.pythonhosted.orgpackages954c063a912e20bcef7124e0df97282a8af3ff3e4b603ce84c481d6d7346be0awrapt-1.16.0.tar.gz"
    sha256 "5f370f952971e7d17c7d1ead40e49f32345a7f7a5373571ef44d800d06b1899d"
  end

  resource "zipp" do
    url "https:files.pythonhosted.orgpackagesd320b48f58857d98dcb78f9e30ed2cfe533025e2e9827bbd36ea0a64cc00cbc1zipp-3.19.2.tar.gz"
    sha256 "bf1dcf6450f873a13e952a29504887c89e6de7506209e5b1bcc3460135d4de19"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    ENV.deparallelize
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      # `--no-depexts` prevents opam from attempting to automatically search for
      # and install system dependencies using the os-native package manager.
      # On Linux, this leads to confusing and inaccurate `Missing dependency`
      # errors due to querying `apt`. See:
      #   https:github.comHomebrewhomebrew-corepull82693
      #   https:github.comHomebrewhomebrew-corepull176636
      #   https:github.comocamlopampull4548
      ENV["OPAMNODEPEXTS"] = ENV["OPAMYES"] = "1"
      # Set library path so opam + lwt can find libev
      ENV["LIBRARY_PATH"] = "#{HOMEBREW_PREFIX}lib"
      # Set path to libev for our static linking logic
      ENV["SEMGREP_LIBEV_ARCHIVE_PATH"] = "#{HOMEBREW_PREFIX}liblibev.a"

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      ENV.deparallelize { system "opam", "switch", "create", "ocaml-base-compiler.4.14.0" }

      # Manually run steps from `opam exec -- make setup` to link Homebrew's tree-sitter
      system "opam", "update", "-y"
      system "opam", "install", "-y", "--deps-only", ".libsocaml-tree-sitter-core"
      system "opam", "install", "-y", "--deps-only", "."
      cd ".libsocaml-tree-sitter-core" do
        system ".configure"
      end

      # Install semgrep-core and spacegrep
      system "opam", "exec", "--", "make", "core"
      system "opam", "exec", "--", "make", "copy-core-for-cli"

      bin.install "_buildinstalldefaultbinsemgrep-core" => "semgrep-core"
    end

    ENV["SEMGREP_SKIP_BIN"] = "1"
    venv = virtualenv_create(libexec, "python3.12")
    venv.pip_install resources.reject { |r| r.name == "glom" }

    # Replace `imp` usage: https:github.commahmoudglomcommit1f883f0db898d6b15fcc0f293225dcccc16b2a57
    # TODO: remove with glom>=23.4.0
    resource("glom").stage do |r|
      inreplace "setup.py", "import imp", ""
      inreplace "setup.py", "_version_mod = imp.load_source('_version', _version_mod_path)", ""
      inreplace "setup.py", "_version_mod.__version__", "'#{r.version}'"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath"cli"

    generate_completions_from_executable(bin"semgrep", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    system bin"semgrep", "--help"
    (testpath"script.py").write <<~EOS
      def silly_eq(a, b):
        return a + b == a + b
    EOS

    output = shell_output("#{bin}semgrep script.py -l python -e '$X == $X'")
    assert_match "a + b == a + b", output

    (testpath"script.ts").write <<~EOS
      function test_equal() {
        a = 1;
        b = 2;
        ERROR: match
        if (a + b == a + b)
            return 1;
        return 0;
      }
    EOS

    output = shell_output("#{bin}semgrep script.ts -l ts -e '$X == $X'")
    assert_match "a + b == a + b", output
  end
end