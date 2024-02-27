class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https:semgrep.dev"
  url "https:github.comsemgrepsemgrep.git",
      tag:      "v1.62.0",
      revision: "d50609f50e350defae20f2f3d010341c5f4c6f1a"
  license "LGPL-2.1-only"
  head "https:github.comsemgrepsemgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "982709f5b1190abb5fa725a76f0cded4471abdd4307e9f4cff6945b1d87e4ec2"
    sha256 cellar: :any,                 arm64_ventura:  "d9a21838a265ff99bd779ea055fff76793ecf859dc1d3e5f13ee0713c95bc7cb"
    sha256 cellar: :any,                 arm64_monterey: "35091e3234b0fd6df7318dcfdcd6a9193638889979c5417e426c9912c0baf150"
    sha256 cellar: :any,                 sonoma:         "d93e8a2237648783c3221268d0c0b3cf1e78495e796bdff351fca416d721d9a2"
    sha256 cellar: :any,                 ventura:        "aa2066cd6ef5c73443473aaab1c19a288be20ccf195fe2a307d57abe1d4b0c2f"
    sha256 cellar: :any,                 monterey:       "d167681bc536c227de0116b1a8eb200066e04da0e461e7f8e2d4dfcc7d74effa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b95a03a7eff5eea8bec2e85c8e613cd5af6b1f81342d39efecd5ee36d1870355"
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
  depends_on "gmp"
  depends_on "libev"
  depends_on "pcre"
  depends_on "python-certifi"
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
    url "https:files.pythonhosted.orgpackages8e1cbeef724eaf5b01bb44b6338c8c3494eff7cab376fab4904cfbbc3585dc79exceptiongroup-1.2.0.tar.gz"
    sha256 "91f5c769735f051a4290d52edd0858999b57e5876e9f85937691bd4c9fa3ed68"
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
    url "https:files.pythonhosted.orgpackagesbf3fea4b9117521a1e9c50344b909be7886dd00a519552724809bb1f486986c2idna-3.6.tar.gz"
    sha256 "9ecdbbd083b06798ae1e86adcbfe8ab1479cf864e4ee30fe4e46a003d12491ca"
  end

  resource "jsonschema" do
    url "https:files.pythonhosted.orgpackages4dc53f6165d3df419ea7b0990b3abed4ff348946a826caf0e7c990b65ff7b9bejsonschema-4.21.1.tar.gz"
    sha256 "85727c00279f5fa6bedbe6238d2aa6403bedd8b4864ab11207d07df3cc1b2ee5"
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
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "peewee" do
    url "https:files.pythonhosted.orgpackages8da589cdbc4a7f6d7a0624c120be102db770ee717aa371066581e3daf2beb96fpeewee-3.17.1.tar.gz"
    sha256 "e009ac4227c4fdc0058a56e822ad5987684f0a1fbb20fed577200785102581c3"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages55598bccf4157baf25e4aa5a0bb7fa3ba8600907de105ebc22b0c78cfbf6f565pygments-2.17.2.tar.gz"
    sha256 "da46cec9fd2de5be3a8a784f434e4c4ab670b4ff54d605c4c2717e9d49c4c367"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages21c5b99dd501aa72b30a5a87d488d7aa76ec05bdf0e2c7439bc82deb9448dd9areferencing-0.33.0.tar.gz"
    sha256 "c775fedf74bc0f9189c2a3be1c12fd03e8c23f4d371dce795df44e06c5b412f7"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa7ec4a7d80728bd429f7c0d4d51245287158a1516315cadbb146012439403a9drich-13.7.0.tar.gz"
    sha256 "5cb5123b5cf9ee70584244246816e9114227e0b98ad9176eede6ad54bf5403fa"
  end

  resource "rpds-py" do
    url "https:files.pythonhosted.orgpackages55bace7b9f0fc5323f20ffdf85f682e51bee8dc03e9b54503939ebb63d1d0d5erpds_py-0.18.0.tar.gz"
    sha256 "42821446ee7a76f5d9f71f9e33a4fb2ffd724bb3e7f93386150b61a43115788d"
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
    url "https:files.pythonhosted.orgpackages0c1deb26f5e75100d531d7399ae800814b069bc2ed2a7410834d57374d010d96typing_extensions-4.9.0.tar.gz"
    sha256 "23478f88c37f27d76ac8aee6c905017a143b0b1b886c3c9f66bc2fd94f9f5783"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages7a507fd50a27caa0652cd4caf224aa87741ea41d3265ad13f010886167cfcc79urllib3-2.2.1.tar.gz"
    sha256 "d0570876c61ab9e520d776c38acbbb5b05a776d3f9ff98a5c8fd5162a444cf19"
  end

  resource "wcmatch" do
    url "https:files.pythonhosted.orgpackages38c60c5f324561c9396868d6badf571590c1a7802a81180c3097e4dfdc2f35c0wcmatch-8.5.1.tar.gz"
    sha256 "c0088c7f6426cf6bf27e530e2b7b734031905f7e490475fd83c7c5008ab581b3"
  end

  def install
    ENV.deparallelize
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"
      # Set library path so opam + lwt can find libev
      ENV["LIBRARY_PATH"] = "#{HOMEBREW_PREFIX}lib"

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
    python_path = "cli"
    cd python_path do
      venv = virtualenv_create(libexec, Formula["python@3.11"].bin"python3.11")
      venv.pip_install resources.reject { |r| r.name == "ocaml-tree-sitter" }
      venv.pip_install_and_link buildpathpython_path
    end

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