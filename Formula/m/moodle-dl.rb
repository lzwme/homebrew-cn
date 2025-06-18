class MoodleDl < Formula
  include Language::Python::Virtualenv

  desc "Downloads course content fast from Moodle (e.g., lecture PDFs)"
  homepage "https:github.comC0D3D3VMoodle-DL"
  url "https:files.pythonhosted.orgpackages0b449c283a04b0ede0bcaa2f3595b523cb115c662fe349f215631484035126d1moodle_dl-2.3.13.tar.gz"
  sha256 "7a6d813b3241497fb79a34a428aa266b2d2d3c175e05d46752e0a8040adaddce"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4edaba781d9d735a2716e1eb87a7453754556d33293d0dd002840dedaac4f1c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62550b7e608fc4dad74af47a99eae725913d28850f12a781ba2d166fafb9a2af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6c5967df3f89b9ab620d22f60f2b3bfcb6bb927bc503166000962bd0efcd8953"
    sha256 cellar: :any_skip_relocation, sonoma:        "9f42ac47c652fb79c1c8142b2e4ae703d2bcfdb32563e6b83720e6fa98e1c247"
    sha256 cellar: :any_skip_relocation, ventura:       "e6d57095cf2fe5267bd38c73e43bfb6523a2923ac27c558ca4dc6de94fab8169"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f758c3bc202c784a219c519043807a628c78499eafc091b886828b20ca9e105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17f020ecba04b74fe8bd814888ae07379275625fea606e4a9f5f36b450bc0e10"
  end

  depends_on "certifi"
  depends_on "ffmpeg"
  depends_on "python@3.13"

  resource "aiodns" do
    url "https:files.pythonhosted.orgpackages170a163e5260cecc12de6abc259d158d9da3b8ec062ab863107dcdb1166cdcefaiodns-3.5.0.tar.gz"
    sha256 "11264edbab51896ecf546c18eb0dd56dff0428c6aa6d2cd87e643e07300eb310"
  end

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackages0b03a88171e277e8caa88a4c77808c20ebb04ba74cc4681bf1e9416c862de237aiofiles-24.1.0.tar.gz"
    sha256 "22a075c9e5a3810f0c2e48f3008c94d68c65d763b9b03857924c99e57355166c"
  end

  resource "aiohappyeyeballs" do
    url "https:files.pythonhosted.orgpackages2630f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https:files.pythonhosted.orgpackages426eab88e7cb2a4058bed2f7870276454f85a7c56cd6da79349eb314fc7bbcaaaiohttp-3.12.13.tar.gz"
    sha256 "47e2da578528264a12e4e3dd8dd72a7289e5f812758fe086473fab037a10fcce"
  end

  resource "aiosignal" do
    url "https:files.pythonhosted.orgpackagesbab56d55e80f6d8a08ce22b982eafa278d823b541c925f11ee774b0b9c43473daiosignal-1.3.2.tar.gz"
    sha256 "a8c255c66fafb1e499c9351d0bf32ff2d8a0321595ebac3b93713656d2436f54"
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages5ab01367933a8532ee6ff8d63537de4f1177af4bff9f3e829baf7331f595bb24attrs-25.3.0.tar.gz"
    sha256 "75d7cefc7fb576747b2c81b4442d4d4a1ce0900973527c011d1030fd3bf4af1b"
  end

  resource "cffi" do
    url "https:files.pythonhosted.orgpackagesfc97c783634659c2920c3fc70419e3af40972dbaf758daa229a7d6ea6135c90dcffi-1.17.1.tar.gz"
    sha256 "1c39c6016c32bc48dd54561950ebd6836e1670f2ae46128f67cf49e789c52824"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "colorama" do
    url "https:files.pythonhosted.orgpackagesd8536f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "colorlog" do
    url "https:files.pythonhosted.orgpackagesd37a359f4d5df2353f26172b3cc39ea32daa39af8de522205f512f458923e677colorlog-6.9.0.tar.gz"
    sha256 "bfba54a1b93b94f54e1f4fe48395725a3d92fd2a4af702f6bd70946bdc0c6ac2"
  end

  resource "frozenlist" do
    url "https:files.pythonhosted.orgpackages79b1b64018016eeb087db503b038296fd782586432b9c077fc5c7839e9cb6ef6frozenlist-1.7.0.tar.gz"
    sha256 "2e310d81923c2437ea8670467121cc3e9b0f76d3043cc1d2331d56c7fb7a3a8f"
  end

  resource "html2text" do
    url "https:files.pythonhosted.orgpackagesf827e158d86ba1e82967cc2f790b0cb02030d4a8bef58e0c79a8590e9678107fhtml2text-2025.4.15.tar.gz"
    sha256 "948a645f8f0bc3abe7fd587019a2197a12436cd73d0d4908af95bfc8da337588"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "multidict" do
    url "https:files.pythonhosted.orgpackages46b559f27b4ce9951a4bce56b88ba5ff5159486797ab18863f2b4c1c5e8465bdmultidict-6.5.0.tar.gz"
    sha256 "942bd8002492ba819426a8d7aefde3189c1b87099cdf18aaaefefcf7f3f7b6d2"
  end

  resource "propcache" do
    url "https:files.pythonhosted.orgpackagesa61643264e4a779dd8588c21a70f0709665ee8f611211bdd2c87d952cfa7c776propcache-0.3.2.tar.gz"
    sha256 "20d7d62e4e7ef05f221e0db2856b979540686342e7dd9973b815599c7057e168"
  end

  resource "pycares" do
    url "https:files.pythonhosted.orgpackagesf5374d4f8ac929e98aad64781f37d9429e82ba65372fc89da0473cdbecdbbb03pycares-4.9.0.tar.gz"
    sha256 "8ee484ddb23dbec4d88d14ed5b6d592c1960d2e93c385d5e52b6fad564d82395"
  end

  resource "pycparser" do
    url "https:files.pythonhosted.orgpackages1db231537cf4b1ca988837256c910a668b553fceb8f069bedc4b1c826024b52cpycparser-2.22.tar.gz"
    sha256 "491c8be9c040f5390f5bf44a5b07752bd07f56edf992381b05c701439eec10f6"
  end

  resource "readchar" do
    url "https:files.pythonhosted.orgpackagesddf88657b8cbb4ebeabfbdf991ac40eca8a1d1bd012011bd44ad1ed10f5cb494readchar-4.2.1.tar.gz"
    sha256 "91ce3faf07688de14d800592951e5575e9c7a3213738ed01d394dcc949b79adb"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "sentry-sdk" do
    url "https:files.pythonhosted.orgpackages044caf31e0201b48469786ddeb1bf6fd3dfa3a291cc613a0fe6a60163a7535f9sentry_sdk-2.30.0.tar.gz"
    sha256 "436369b02afef7430efb10300a344fb61a11fe6db41c2b11f41ee037d2dd7f45"
  end

  resource "six" do
    url "https:files.pythonhosted.orgpackages94e7b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "xmpppy" do
    url "https:files.pythonhosted.orgpackagesb9dcc82cf11d776b371863bef8de412e949467e291977d2aaded91d010713a6fxmpppy-0.7.1.tar.gz"
    sha256 "c5ff61c0fa0ad8b9e521939f944bbcdac0a2375e7ec24201605cc540857e0400"
  end

  resource "yarl" do
    url "https:files.pythonhosted.orgpackages3cfbefaa23fa4e45537b827620f04cf8f3cd658b76642205162e072703a5b963yarl-1.20.1.tar.gz"
    sha256 "d017a4997ee50c91fd5466cef416231bb82177b93b029906cefc542ce14c35ac"
  end

  resource "yt-dlp" do
    url "https:files.pythonhosted.orgpackagesb7fb588a23e61586960273524d3aa726bd148116d422854f727f4d59c254cb6ayt_dlp-2025.6.9.tar.gz"
    sha256 "751f53a3b61353522bf805fa30bbcbd16666126537e39706eab4f8c368f111ac"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}moodle-dl --version")

    (testpath"config.json").write <<~JSON
      {
        "token": "invalidtoken",
        "privatetoken": "invalidprivatetoken",
        "moodle_domain": "localhost",
        "moodle_path": "moodle"
      }
    JSON

    assert_match "Connection error", shell_output("#{bin}moodle-dl 2>&1", 1)
    assert_path_exists testpath"moodle_state.db"
  end
end