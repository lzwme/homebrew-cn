class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https:semgrep.dev"
  url "https:github.comsemgrepsemgrep.git",
      tag:      "v1.74.0",
      revision: "115c9eb4b315380501bfc6a89138d3f7ee47ed5f"
  license "LGPL-2.1-only"
  head "https:github.comsemgrepsemgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6067f91de1b10d5b809ff60def1befa6c9d18ed48401f9d70c79162ec9e21567"
    sha256 cellar: :any,                 arm64_ventura:  "b79b790664934f806478de20b5ac31bc180ccf2f9ba54b18e525cd59bb0a3a32"
    sha256 cellar: :any,                 arm64_monterey: "baa4718948f47fef88e8f52064b19c42bc42eb1b0e5f42714c137fbd4694b4b7"
    sha256 cellar: :any,                 sonoma:         "120bf94a3d23d2d58c58828b1e750f62aa02e262fc9b9a1fd54ab635b062707c"
    sha256 cellar: :any,                 ventura:        "e81ff7695129260f6e6fe9d67273477e27b94e6c64325eeef5acf967cea4ff14"
    sha256 cellar: :any,                 monterey:       "e07f8aee52d5c350a584c8cac6c1be4aa6c1d0ed25e34184f6e9619475d1f187"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb81f25b51c3f97180ea6c5052d73c7ce72d978017a9af43dc8f160730ef2f41"
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
  depends_on "python@3.11" # Python 3.12 blocked by imp usage in glom < 23.4.0
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

  resource "exceptiongroup" do
    url "https:files.pythonhosted.orgpackagesa065d66b7fbaef021b3c954b3bbb196d21d8a4b97918ea524f82cfae474215afexceptiongroup-1.2.1.tar.gz"
    sha256 "a4785e48b045528f5bfe627b6ad554ff32def154f42372786903b7abcfe1aa16"
  end

  resource "face" do
    url "https:files.pythonhosted.orgpackagesd7bc4d0f6c1e095eb977782edd94245f84b69c6f8df152480c78ab310e895098face-22.0.0.tar.gz"
    sha256 "d5d692f90bc8f5987b636e47e36384b9bbda499aaf0a77aa0b0bbe834c76923d"
  end

  resource "glom" do
    url "https:files.pythonhosted.orgpackages3fd169432deefa6f5283ec75b246d0540097ae26f618b915519ee3824c4c5dd6glom-22.1.0.tar.gz"
    sha256 "1510c6587a8f9c64a246641b70033cbc5ebde99f02ad245693678038e821aeb5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages19f11c1dc0f6b3bf9e76f7526562d29c320fa7d6a2f35b37a1392cc0acd58263jsonschema-4.22.0.tar.gz"
    sha256 "5b22d434a45935119af990552c862e5d6d564e8f6601206b305a61fdf661a2b7"
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

  resource "packaging" do
    url "https:files.pythonhosted.orgpackageseeb5b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4dpackaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "peewee" do
    url "https:files.pythonhosted.orgpackages1ed422c2909b5a0b36e69471e699d673c2985f7691ca29870798a29e0a3d0e2bpeewee-3.17.5.tar.gz"
    sha256 "e1b6a64192207fd3ddb4e1188054820f42aef0aadfa749e3981af3c119a76420"
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
    url "https:files.pythonhosted.orgpackages86ec535bf6f9bd280de6a4637526602a146a68fde757100ecf8c9333173392dbrequests-2.32.2.tar.gz"
    sha256 "dd951ff5ecf3e3b3aa26b40703ba77495dab41da839ae72ef3c8e5d8e2433289"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesb301c954e134dc440ab5f96952fe52b4fdc64225530320a910473c1fe270d9aarich-13.7.1.tar.gz"
    sha256 "9be308cb1fe2f1f57d67ce99e95af38a1e2bc71ad9813b0e247cf7ffbcc3a432"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages2daae7c404bdee1db7be09860dff423d022ffdce9269ec8e6532cce09ee7beearpds_py-0.18.1.tar.gz"
    sha256 "dc48b479d540770c811fbd1eb9ba2bb66951863e448efec2e2c102625328e92f"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackagesd1d6eb2833ccba5ea36f8f4de4bcfa0d1a91eb618f832d430b70e3086821f251ruamel.yaml-0.17.40.tar.gz"
    sha256 "6024b986f06765d482b5b07e086cc4b4cd05dd22ddcbc758fa23d54873cf313d"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages46abbab9eb1566cd16f060b54055dd39cf6a34bfa0240c53a7218c43e974295bruamel.yaml.clib-0.2.8.tar.gz"
    sha256 "beb2e0404003de9a4cab9753a8805a8fe9320ee6673136ed7f04255fe60bb512"
  end

  resource "tomli" do
    url "https:files.pythonhosted.orgpackagesc03fd7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf6f3b827b3ab53b4e3d8513914586dcca61c355fa2ce8252dea4da56e67bf8f2typing_extensions-4.11.0.tar.gz"
    sha256 "83f085bd5ca59c80295fc2a82ab5dac679cbe02b9f33f7d83af68e241bea51b0"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "wcmatch" do
    url "https:files.pythonhosted.orgpackageseac455e0d36da61d7b8b2a49fd273e6b296fd5e8471c72ebbe438635d1af3968wcmatch-8.5.2.tar.gz"
    sha256 "a70222b86dea82fb382dd87b73278c10756c138bd6f8f714e2183128887b9eb2"
  end

  def install
    # Work around ruamel.yaml.clib not building on Xcode 15.3, remove after a new release
    # has resolved: https:sourceforge.netpruamel-yaml-clibtickets32
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    ENV.deparallelize
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      # Set library path so opam + lwt can find libev
      ENV["LIBRARY_PATH"] = "#{HOMEBREW_PREFIX}lib"
      # Set path to libev for our static linking logic
      ENV["SEMGREP_LIBEV_ARCHIVE_PATH"] = "#{HOMEBREW_PREFIX}liblibev.a"

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      ENV.deparallelize { system "opam", "switch", "create", "ocaml-base-compiler.4.14.0" }

      # Manually run steps from `opam exec -- make setup` to link Homebrew's tree-sitter
      system "opam", "update", "-y"

      # We pass --no-depexts so as to disable the check for pkg-config.
      # It seems to not be found when building on ubuntu
      # See discussion on https:github.comHomebrewhomebrew-corepull82693
      system "opam", "install", "-y", "--deps-only", "--no-depexts", ".libsocaml-tree-sitter-core"
      system "opam", "install", "-y", "--deps-only", "--no-depexts", "."

      # Run configure script in ocaml-tree-sitter-core
      cd ".libsocaml-tree-sitter-core" do
        system ".configure"
      end

      # Install semgrep-core and spacegrep
      system "opam", "install", "--deps-only", "-y", "."
      system "opam", "exec", "--", "make", "core"
      system "opam", "exec", "--", "make", "copy-core-for-cli"

      bin.install "_buildinstalldefaultbinsemgrep-core" => "semgrep-core"
    end

    ENV["SEMGREP_SKIP_BIN"] = "1"
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    venv.pip_install_and_link buildpath"cli"

    generate_completions_from_executable(bin"semgrep", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    system "#{bin}semgrep", "--help"
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