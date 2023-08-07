class Semgrep < Formula
  include Language::Python::Virtualenv

  desc "Easily detect and prevent bugs and anti-patterns in your codebase"
  homepage "https://semgrep.dev"
  url "https://github.com/returntocorp/semgrep.git",
      tag:      "v1.34.1",
      revision: "8bb2770557395b25529abbb2f3f3a6c26aaee33f"
  license "LGPL-2.1-only"
  head "https://github.com/returntocorp/semgrep.git", branch: "develop"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_ventura:  "ba3f400287c178b91a11199e45869a65f50c3b3da12e571f12e62a789381de19"
    sha256 cellar: :any, arm64_monterey: "63b178366022e15091f5e125d6548fa259b312c00c8a44bfea58c74fb4624264"
    sha256 cellar: :any, arm64_big_sur:  "0fbc08ba2b98685e40a6268a86967399d161bcfe421634a31a6f0303f9cc5e28"
    sha256 cellar: :any, ventura:        "a3f016492fae19b0d0f698e61288697cd74d14860ae543653d5401ea7a5cbb5c"
    sha256 cellar: :any, monterey:       "e51d68b8452bc31021ac2b4648a3fc1b9afbd388dc0af50463b3dea8a8ebff95"
    sha256 cellar: :any, big_sur:        "86f5dbfa1a1ca4d4b153b7a3a7e1190e4a9806134b04010f22a5c0c505662a61"
    sha256               x86_64_linux:   "47898a08b09dc30028162f00377b59aaa8738a1dfc43a8db5acb9a5c9149852f"
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
  depends_on "pcre"
  depends_on "pygments"
  depends_on "python-certifi"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "tree-sitter"

  uses_from_macos "rsync" => :build

  fails_with gcc: "5"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/97/90/81f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbb/attrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "boltons" do
    url "https://files.pythonhosted.org/packages/ad/1f/6c0608d86e0fc77c982a2923ece80eef85f091f2332fc13cbce41d70d502/boltons-21.0.0.tar.gz"
    sha256 "65e70a79a731a7fe6e98592ecfb5ccf2115873d01dbc576079874629e5c90f13"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/b3/96/d53e290ddf6215cfb24f93449a1835eff566f79a1f332cf046a978df0c9e/bracex-2.3.post1.tar.gz"
    sha256 "e7b23fc8b2cd06d3dec0692baabecb249dda94e06a617901ff03a6c56fd71693"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "click-option-group" do
    url "https://files.pythonhosted.org/packages/e7/b8/91054601a2e05fd9060cb1baf56be5b24145817b059e078669e1099529c7/click-option-group-0.5.6.tar.gz"
    sha256 "97d06703873518cc5038509443742b25069a3c7562d1ea72ff08bfadde1ce777"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "face" do
    url "https://files.pythonhosted.org/packages/d7/bc/4d0f6c1e095eb977782edd94245f84b69c6f8df152480c78ab310e895098/face-22.0.0.tar.gz"
    sha256 "d5d692f90bc8f5987b636e47e36384b9bbda499aaf0a77aa0b0bbe834c76923d"
  end

  resource "glom" do
    url "https://files.pythonhosted.org/packages/3f/d1/69432deefa6f5283ec75b246d0540097ae26f618b915519ee3824c4c5dd6/glom-22.1.0.tar.gz"
    sha256 "1510c6587a8f9c64a246641b70033cbc5ebde99f02ad245693678038e821aeb5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/e5/a2/3e03efdd25f93e1296d0454a7680456fda2925f2ff624bf43855d785b3bd/jsonschema-4.18.4.tar.gz"
    sha256 "fb3642735399fa958c0d2aad7057901554596c63349f4f6b283c493cf692a25d"
  end

  resource "jsonschema-specifications" do
    url "https://files.pythonhosted.org/packages/12/ce/eb5396b34c28cbac19a6a8632f0e03d309135d77285536258b82120198d8/jsonschema_specifications-2023.7.1.tar.gz"
    sha256 "c91a50404e88a1f6ba40636778e2ee08f6e24c5613fe4c53ac24578a5a7f72bb"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/38/71/3b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0/markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "peewee" do
    url "https://files.pythonhosted.org/packages/a9/50/1dd5ea74c559df4afb8391f8d05f0fec685dbe8effba13bb9072901eb288/peewee-3.16.2.tar.gz"
    sha256 "10769981198c7311f84a0ca8db892fa213303a8eb1305deb795a71e7bd606a91"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/99/45/1c2a272950679af529f7360af6ee567ef266f282e451be926329e8d50d84/python-lsp-jsonrpc-1.0.0.tar.gz"
    sha256 "7bec170733db628d3506ea3a5288ff76aa33c70215ed223abdb0d95e957660bd"
  end

  resource "referencing" do
    url "https://files.pythonhosted.org/packages/ae/0e/5a4c22e046dc8c94fec2046255ddd7068b7aaff66b3d0d0dd2cfbf8a7b20/referencing-0.30.0.tar.gz"
    sha256 "47237742e990457f7512c7d27486394a9aadaf876cbfaa4be65b27b4f4d47c6b"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/e3/12/67d0098eb77005f5e068de639e6f4cfb8f24e6fcb0fd2037df0e1d538fee/rich-13.4.2.tar.gz"
    sha256 "d653d6bccede5844304c605d5aac802c7cf9621efd700b46c7ec2b51ea914898"
  end

  resource "rpds-py" do
    url "https://files.pythonhosted.org/packages/da/3c/fa2701bfc5d67f4a23f1f0f4347284c51801e9dbc24f916231c2446647df/rpds_py-0.9.2.tar.gz"
    sha256 "8d70e8f14900f2657c249ea4def963bed86a29b81f81f5b76b5a9215680de945"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/63/dd/b4719a290e49015536bd0ab06ab13e3b468d8697bec6c2f668ac48b05661/ruamel.yaml-0.17.32.tar.gz"
    sha256 "ec939063761914e14542972a5cba6d33c23b0859ab6342f61cf070cfc600efc2"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/15/16/ff0a051f9a6e122f07630ed1e9cbe0e0b769273e123673f0d2aa17fe3a36/ujson-5.8.0.tar.gz"
    sha256 "78e318def4ade898a461b3d92a79f9441e7e0e4d2ad5419abed4336d702c7425"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/b7/94/5dd083fc972655f6689587c3af705aabc8b8e781bacdf22d6d2282fe6142/wcmatch-8.4.1.tar.gz"
    sha256 "b1f042a899ea4c458b7321da1b5e3331e3e0ec781583434de1301946ceadb943"
  end

  def install
    ENV.deparallelize
    Dir.mktmpdir("opamroot") do |opamroot|
      ENV["OPAMROOT"] = opamroot
      ENV["OPAMYES"] = "1"

      system "opam", "init", "--no-setup", "--disable-sandboxing"
      ENV.deparallelize { system "opam", "switch", "create", "ocaml-base-compiler.4.14.0" }

      # Manually run steps from `opam exec -- make setup` to link Homebrew's tree-sitter
      system "opam", "update", "-y"

      # We pass --no-depexts so as to disable the check for pkg-config.
      # It seems to not be found when building on ubuntu
      # See discussion on https://github.com/Homebrew/homebrew-core/pull/82693
      system "opam", "install", "-y", "--deps-only", "--no-depexts", "./libs/ocaml-tree-sitter-core"
      system "opam", "install", "-y", "--deps-only", "--no-depexts", "./"

      # Run configure script in ocaml-tree-sitter-core
      cd "./libs/ocaml-tree-sitter-core" do
        system "./configure"
      end

      # Install semgrep-core and spacegrep
      system "opam", "install", "--deps-only", "-y", "."
      system "opam", "exec", "--", "make", "core"
      system "opam", "exec", "--", "make", "core-install"
      bin.install "_build/install/default/bin/semgrep-core" => "semgrep-core"
    end

    ENV["SEMGREP_SKIP_BIN"] = "1"
    python_path = "cli"
    cd python_path do
      venv = virtualenv_create(libexec, Formula["python@3.11"].bin/"python3.11")
      venv.pip_install resources.reject { |r| r.name == "ocaml-tree-sitter" }
      venv.pip_install_and_link buildpath/python_path
    end
  end

  test do
    system "#{bin}/semgrep", "--help"
    (testpath/"script.py").write <<~EOS
      def silly_eq(a, b):
        return a + b == a + b
    EOS

    output = shell_output("#{bin}/semgrep script.py -l python -e '$X == $X'")
    assert_match "a + b == a + b", output

    (testpath/"script.ts").write <<~EOS
      function test_equal() {
        a = 1;
        b = 2;
        //ERROR: match
        if (a + b == a + b)
            return 1;
        return 0;
      }
    EOS

    output = shell_output("#{bin}/semgrep script.ts -l ts -e '$X == $X'")
    assert_match "a + b == a + b", output
  end
end