class Pyspelling < Formula
  include Language::Python::Virtualenv

  desc "Spell checker automation tool"
  homepage "https://facelessuser.github.io/pyspelling/"
  url "https://files.pythonhosted.org/packages/67/94/7975a04dd17c815b45f5f75fa07a49770b5f230320672dea155ea0a3ca14/pyspelling-2.11.tar.gz"
  sha256 "94cc6efa979c26779601ad666f8d986adf52d247b313337ad67aac7163749d0e"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "89819bd6cc7ff5d2086219eeea23cc02919df6c0b285d75c8345df25ab811cd1"
    sha256 cellar: :any,                 arm64_sequoia: "969cbf03524de3d355d2c40fa209014ea1894cb7bbacb319b5c61dc4796e8a69"
    sha256 cellar: :any,                 arm64_sonoma:  "6e9be9f3470b46ceb00ebd748ffcd1c54fed46e98081a4c3213aa51e703a6c74"
    sha256 cellar: :any,                 sonoma:        "46d705386136a7c97696bc228d6f093c8575cdbcacdea64f8edcdacec2b735ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a1391454dac6b31301316c09cf9a1c414d379e1322e931489c336cf6ee91223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8dddabe9caaca026b54f5860a184fe8e5dfec18c2174d2ac7c8bd976af51e70d"
  end

  depends_on "aspell" => :test
  depends_on "libyaml"
  depends_on "python@3.14"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/77/e9/df2358efd7659577435e2177bfa69cba6c33216681af51a707193dec162a/beautifulsoup4-4.14.2.tar.gz"
    sha256 "2a98ab9f944a11acee9cc848508ec28d9228abfd522ef0fad6a02a72e0ded69e"
  end

  resource "bracex" do
    url "https://files.pythonhosted.org/packages/63/9a/fec38644694abfaaeca2798b58e276a8e61de49e2e37494ace423395febc/bracex-2.6.tar.gz"
    sha256 "98f1347cd77e22ee8d967a30ad4e310b233f7754dbf31ff3fceb76145ba47dc7"
  end

  resource "html5lib" do
    url "https://files.pythonhosted.org/packages/ac/b6/b55c3f49042f1df3dcd422b7f224f939892ee94f22abcf503a9b7339eaf2/html5lib-1.1.tar.gz"
    sha256 "b2e5b40261e20f354d198eae92afc10d750afb487ed5e50f9c4eaf07c184146f"

    # Fix to build with Python 3.14
    # PR ref: https://github.com/html5lib/html5lib-python/pull/589
    patch do
      url "https://github.com/html5lib/html5lib-python/commit/b90dafff1bf342d34d539098013d0b9f318c7641.patch?full_index=1"
      sha256 "779f8bab52308792b7ac2f01c3cd61335587640f98812c88cb074dce9fe8162d"
    end
  end

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/aa/88/262177de60548e5a2bfc46ad28232c9e9cbde697bd94132aeb80364675cb/lxml-6.0.2.tar.gz"
    sha256 "cd79f3367bd74b317dda655dc8fcfa304d9eb6e4fb06b7168c5cf27f96e0cd62"
  end

  resource "markdown" do
    url "https://files.pythonhosted.org/packages/8d/37/02347f6d6d8279247a5837082ebc26fc0d5aaeaf75aa013fcbb433c777ab/markdown-3.9.tar.gz"
    sha256 "d2900fe1782bd33bdbbd56859defef70c2e78fc46668f8eb9df3128138f2cb6a"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/6d/e6/21ccce3262dd4889aa3332e5a119a3491a95e8f60939870a3a035aabac0d/soupsieve-2.8.tar.gz"
    sha256 "e2dd4a40a628cb5f28f6d4b0db8800b8f581b65bb380b97de22ba5ca8d72572f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/72/94/1a15dd82efb362ac84269196e94cf00f187f7ed21c242792a923cdb1c61f/typing_extensions-4.15.0.tar.gz"
    sha256 "0cea48d173cc12fa28ecabc3b837ea3cf6f38c6d1136f85cbaaf598984861466"
  end

  resource "wcmatch" do
    url "https://files.pythonhosted.org/packages/79/3e/c0bdc27cf06f4e47680bd5803a07cb3dfd17de84cde92dd217dcb9e05253/wcmatch-10.1.tar.gz"
    sha256 "f11f94208c8c8484a16f4f48638a85d771d9513f4ab3f37595978801cb9465af"
  end

  resource "webencodings" do
    url "https://files.pythonhosted.org/packages/0b/02/ae6ceac1baeda530866a85075641cec12989bd8d31af6d5ab4a3e8c92f47/webencodings-0.5.1.tar.gz"
    sha256 "b36a1c245f2d304965eb4e0a82848379241dc04b865afcc4aab16748587e1923"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath / "text.txt").write("Homebrew is my favourite package manager!")
    (testpath / "en-custom.txt").write("homebrew")
    (testpath / ".pyspelling.yml").write <<~YAML
      spellchecker: aspell
      matrix:
      - name: Python Source
        aspell:
          lang: en
          d: en_US
        dictionary:
          wordlists:
          - #{testpath}/en-custom.txt
        sources:
        - #{testpath}/text.txt
    YAML

    output = shell_output(bin/"pyspelling", 1)
    assert_match <<~EOS, output
      Misspelled words:
      <text> #{testpath}/text.txt
      --------------------------------------------------------------------------------
      favourite
      --------------------------------------------------------------------------------
    EOS
  end
end