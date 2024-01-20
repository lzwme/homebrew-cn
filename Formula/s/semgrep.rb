class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https:semgrep.dev"
  url "https:github.comsemgrepsemgrep.git",
      tag:      "v1.57.0",
      revision: "057f6c15b70446466c7f15fb958fda14c7066574"
  license "LGPL-2.1-only"
  head "https:github.comsemgrepsemgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "b3ebfcde409d8a0653049be3eb36feaeed189e4eb12bb7b25eb49e8189775fcc"
    sha256 cellar: :any, arm64_ventura:  "867350e3e1c674c8e9546462dac8ca30150e994e924ac0c115e6c860365f7a91"
    sha256 cellar: :any, arm64_monterey: "221f0f93a6206548833a29958ac5dbd9c560722d365ea10f446b7acf3b52414e"
    sha256 cellar: :any, sonoma:         "2e6d90b129309139450a090e270873a24c717a648e0dd99030db6d983978ad79"
    sha256 cellar: :any, ventura:        "b6f8f6038f516ab587e1a4ce7332beff90182ee47bdf2a8e4d21e38ba397a655"
    sha256 cellar: :any, monterey:       "b37c560c038472b908d3845670a0f2507ae75ef7ca06f4ad088185241bcc2c8b"
    sha256               x86_64_linux:   "aba2e8942659568f77ebd444ce6391e0fd9fbda6783a11e9fea55c78d3c288a5"
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
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-packaging"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "tree-sitter"

  uses_from_macos "rsync" => :build

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
    url "https:files.pythonhosted.orgpackages44cd1d325d358d856da96a7c6cfc2af486b70587dc4c70594aa2a9e6c2d279adjsonschema-4.21.0.tar.gz"
    sha256 "3ba18e27f7491ea4a1b22edce00fb820eec968d397feb3f9cb61d5894bb38167"
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

  resource "peewee" do
    url "https:files.pythonhosted.orgpackages6a30a727bb1420076b3c14b60911d111f0fc0449d31a1123a1ad18878a7a4e40peewee-3.17.0.tar.gz"
    sha256 "3a56967f28a43ca7a4287f4803752aeeb1a57a08dee2e839b99868181dfb5df8"
  end

  resource "referencing" do
    url "https:files.pythonhosted.orgpackages81ce910573eca7b1a1c6358b0dc0774ce1eeb81f4c98d4ee371f1c85f22040a1referencing-0.32.1.tar.gz"
    sha256 "3c57da0513e9563eb7e203ebe9bb3a1b509b042016433bd1e45a2853466c3dd3"
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
    url "https:files.pythonhosted.orgpackagesb70ae3bdcc977e6db3bf32a3f42172f583adfa7c3604091a03d512333e0161ferpds_py-0.17.1.tar.gz"
    sha256 "0210b2668f24c078307260bf88bdac9d6f1093635df5123789bfee4d8d7fc8e7"
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

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "wcmatch" do
    url "https:files.pythonhosted.orgpackages925172ce10501dbfe508808fd6a637d0a35d1b723a5e8c470f3d6e9458a4f415wcmatch-8.5.tar.gz"
    sha256 "86c17572d0f75cbf3bcb1a18f3bf2f9e72b39a9c08c9b4a74e991e1882a8efb3"
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