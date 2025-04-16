class Pferd < Formula
  include Language::Python::Virtualenv

  desc "Programm zum Flotten Einfachen Runterladen von Dateien"
  homepage "https:github.comGarmelonPFERD"
  url "https:files.pythonhosted.orgpackages52302eb6a1246b3964763acc1210b24810d5af30d8dde20d0ae1796d696d14c3pferd-3.8.0.tar.gz"
  sha256 "3a17c63bd9e135bd725bc3eadb479739e3e2f8124887cc96f87e076d534bde28"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "697024153bf75cc11a0f977cadbcbbfd99669748591c2613096664ed1cc70898"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "617c9ec272ef0b1c85d13d47404d937dd3b523806b797010a03952c8d452ba7b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "20013035dce7da0efee6fbc9bfbd115b025f254610a8d632e75e57749b4b8f5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e58b26f22e7e0365d5fe293da26b26851d400f31e2d5e18df4cb412c30ffd3b4"
    sha256 cellar: :any_skip_relocation, ventura:       "16186b882299ee63d6726c76c5996a5e36434df8045549c6f8ee3330c7ea2e36"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "807e641cfe73887aa0af9f827084597369bb6d084f07dd397c3fd387a0d59b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "088d1af3b6fe081ce9a1ca7224385177e83b0a1013a680852242514b4b048be2"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.13"

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackagesf1d91c4721d143e14af753f2bf5e3b681883e1f24b592c0482df6fa6e33597faaiohttp-3.11.16.tar.gz"
    sha256 "16f8a2c9538c14a557b4d309ed4d0a7c60f0253e8ed7b6c9a2859a7582f8b1b8"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "beautifulsoup4" do
    url "https:files.pythonhosted.orgpackagesd8e40c4c39e18fd76d6a628d4dd8da40543d136ce2d1752bd6eeeab0791f4d6bbeautifulsoup4-4.13.4.tar.gz"
    sha256 "dbb3c4e1ceae6aefebdaf2423247260cd062430a410e38c66f2baa50a8437195"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages8fed0f4cec13a93c02c47ec32d81d11c0c1efbadf4a471e3f3ce7cad366cbbd3frozenlist-1.5.0.tar.gz"
    sha256 "81d5af29e61b9c8348e876d442253723928dce6433e0e76cd925cd83f1b4b817"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https:files.pythonhosted.orgpackagesdfadf3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackagesab239894b3df5d0a6eb44611c36aec777823fc2e07740dabbd0b810e19594013jaraco_functools-4.1.0.tar.gz"
    sha256 "70f7e0e2ae076498e212562325e805204fc092d7b4c17e0e86c959e249701a9d"
  end

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackages7b6f357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0cjeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages7009d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37dkeyring-25.6.0.tar.gz"
    sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages883b7fa1fe835e2e93fd6d7b52b2f95ae810cf5ba133e1845f726f5a992d62c2more-itertools-10.6.0.tar.gz"
    sha256 "2cd7fad1009c31cc9fb6a035108509e6547547a7a738374f10bd49a09eb3ee3b"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackagesda2ce367dfb4c6538614a0c9453e510d75d66099edf1c4e69da1b5ce691a1931multidict-6.4.3.tar.gz"
    sha256 "3ada0b058c9f213c5f95ba301f922d402ac234f1111a7d8fd70f1b99f3c281ec"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackages07c8fdc6686a986feae3541ea23dcaa661bd93972d3940460646c6bb96e21c40propcache-0.3.1.tar.gz"
    sha256 "40d980c33765359098837527e18eddefc9a24cea5b45e078a7f3bb5b032c6ecf"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesa153830aa4c3066a8ab0ae9a9955976fb770fe9c6102117c8ec4ab3ea62d89e8rich-14.0.0.tar.gz"
    sha256 "82f1bc23a6a21ebca4ae0c45af9bdbc492ed20231dcb63f297d6d1021a9d5725"
  end

  resource "secretstorage" do
    url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  resource "soupsieve" do
    url "https:files.pythonhosted.orgpackagesd7cefbaeed4f9fb8b2daa961f90591662df6a86c1abf25c548329a86920aedfbsoupsieve-2.6.tar.gz"
    sha256 "e2e68417777af359ec65daac1057404a3c8a5455bb8abc36f1a9866ab1a51abb"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesf63723083fcd6e35492953e8d2aaaa68b860eb422b34627b13f2ce3eb6106061typing_extensions-4.13.2.tar.gz"
    sha256 "e6c81219bd689f51865d9e372991c540bda33a0379d5573cddb9a3a23f7caaef"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackagesfc4d8a8f57caccce49573e567744926f88c6ab3ca0b47a257806d1cf88584c5fyarl-1.19.0.tar.gz"
    sha256 "01e02bb80ae0dbed44273c304095295106e1d9470460e773268a27d11e594892"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "PFERD #{version} (#{homepage})", shell_output("#{bin}pferd --version").strip

    assert_match "Error Failed to load config", shell_output(bin"pferd", 1)

    (testpath"pferd.cfg").write <<~EOS
      [crawl:Foo]
      type = kit-ilias-web
      target = 1234567
    EOS
    assert_match "key 'auth': Missing value", shell_output("#{bin}pferd -c #{testpath}pferd.cfg", 1)
  end
end