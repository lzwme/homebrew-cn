class Tern < Formula
  include Language::Python::Virtualenv

  desc "Software Bill of Materials (SBOM) tool"
  homepage "https:github.comtern-toolstern"
  url "https:files.pythonhosted.orgpackagesf84b123b2ca469126b45e61853acf028fe1d466f4fe1d5e7afd1d4972c151b4dtern-2.12.1.tar.gz"
  sha256 "c8c22f162962107adb64caaf5f764044e59caa28b9566079e101181c6449a1c0"
  license "BSD-2-Clause"
  head "https:github.comtern-toolstern.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any,                 arm64_sequoia:  "9b899a0da2ec942edee8511cc5a70aac01f75ffc7344829eeec5203633a596c6"
    sha256 cellar: :any,                 arm64_sonoma:   "c927fb71988f1c428da415b7b86f42187ca8f91836b707952d2843555ee3a38a"
    sha256 cellar: :any,                 arm64_ventura:  "9f43227a39c36102b07cf3b87473161543a7ab1c3abe8e24c5577fcea430495a"
    sha256 cellar: :any,                 arm64_monterey: "713f377c08ad16ede820e076a51d72c070e9ff6e02481b6423d35633477aaad7"
    sha256 cellar: :any,                 sonoma:         "7794db7830a6501d0403bd43f7dfa109b969aca8d8e730fb557792a9fea75cea"
    sha256 cellar: :any,                 ventura:        "a9d149cee947ea2e239878f473b1fcceb9ba318adee6264775f9b2f89ebbbc78"
    sha256 cellar: :any,                 monterey:       "2afb6cd919e0a3c50303ca2f0b7fd2b2d53565b3e3a97f4fc9eed3a147cf3702"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71d6a99401e0ab562cb61ef9a51114ea7669a2487211919b9bc61b95d4057af2"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  on_linux do
    depends_on "attr" # for `getfattr`
  end

  resource "attrs" do
    url "https:files.pythonhosted.orgpackages979081f95d5f705be17872843536b1868f351805acf6971251ff07c1b8334dbbattrs-23.1.0.tar.gz"
    sha256 "6279836d581513a26f1bf235f9acd333bc9115683f14f7e8fae46c98fc50e015"
  end

  resource "boolean-py" do
    url "https:files.pythonhosted.orgpackagesa2d9b6e56a303d221fc0bdff2c775e4eef7fedd58194aa5a96fa89fb71634cc9boolean.py-4.0.tar.gz"
    sha256 "17b9a181630e43dde1851d42bef546d616d5d9b4480357514597e78b203d06e4"
  end

  resource "chardet" do
    url "https:files.pythonhosted.orgpackages4132cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430dchardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages2a53cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "debian-inspector" do
    url "https:files.pythonhosted.orgpackages76272bdbfe084be16806c35fcc91bac3236706d1d62751c39a293b2cab77ebccdebian_inspector-31.0.0.tar.gz"
    sha256 "46094f953464b269bb09855eadeee3c92cb6b487a0bfa26eba537b52cc3d6b47"
  end

  resource "docker" do
    url "https:files.pythonhosted.orgpackagesf073f7c9a14e88e769f38cb7fb45aa88dfd795faa8e18aea11bababf6e068d5edocker-6.1.3.tar.gz"
    sha256 "aa6d17830045ba5ef0168d5eaa34d37beeb113948c413affe1d5991fc11f9a20"
  end

  resource "dockerfile-parse" do
    url "https:files.pythonhosted.orgpackages0fc48c4fc1da93a67878b15eaac0d47f467c87be7a12406544b1b33e261a0454dockerfile-parse-2.0.0.tar.gz"
    sha256 "21fe7d510642f2b61a999d45c3d9745f950e11fe6ba2497555b8f63782b78e45"
  end

  resource "gitdb" do
    url "https:files.pythonhosted.orgpackages4b47dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "gitpython" do
    url "https:files.pythonhosted.orgpackages87566dcdfde2f3a747988d1693100224fb88fc1d3bbcb3f18377b2a3ef53a70aGitPython-3.1.32.tar.gz"
    sha256 "8d9b8cb1e80b9735e8717c9362079d3ce4c6e5ddeebedd0361b228c3a67a62f6"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "license-expression" do
    url "https:files.pythonhosted.orgpackages90930fc8c72a5c9b65c2fd56154ef9e08c0c7a7fd0596ae69c65ce714ea5cd84license-expression-30.1.1.tar.gz"
    sha256 "42375df653ad85e6f5b4b0385138b2dbea1f5d66360783d8625c3e4f97f11f0c"
  end

  resource "packageurl-python" do
    url "https:files.pythonhosted.orgpackages91c747a411700a121acc05fe78642b019afe320592078e58c182537c7c65006fpackageurl-python-0.11.1.tar.gz"
    sha256 "bbcc53d2cb5920c815c1626c75992f319bfc450b73893fa7bd8aac5869aa49fe"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackagesfb2b9b9c33ffed44ee921d0967086d653047286054117d584f1b1a7c22ceaf7bpackaging-23.2.tar.gz"
    sha256 "048fb0e9405036518eaaf48a55953c750c11e1a1b68e0dd1a9d62ed0c092cfc5"
  end

  resource "pbr" do
    url "https:files.pythonhosted.orgpackages02d8acee75603f31e27c51134a858e0dea28d321770c5eedb9d1d673eb7d3817pbr-5.11.1.tar.gz"
    sha256 "aefc51675b0b533d56bb5fd1c8c6c0522fe31896679882e1c4c63d5e4a0fccb3"
  end

  resource "prettytable" do
    url "https:files.pythonhosted.orgpackages18fa82e719efc465238383f099c08b5284b974f5002dbe12050bcbbc912366ebprettytable-3.8.0.tar.gz"
    sha256 "031eae6a9102017e8c7c7906460d150b7ed78b20fd1d8c8be4edaf88556c07ce"
  end

  resource "regex" do
    url "https:files.pythonhosted.orgpackages18df401fd39ffd50062ff1e0344f95f8e2c141de4fd1eca1677d2f29609e5389regex-2023.6.3.tar.gz"
    sha256 "72d1a25bf36d2050ceb35b517afe13864865268dfb45910e2e17a84be6cbfeb0"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesc81fe026746e5885a83e1af99002ae63650b7c577af5c424d4c27edcf729ab44setuptools-69.1.1.tar.gz"
    sha256 "5c0806c7d9af348e6dd3777b4f4dbb42c7ad85b190104837488eab9a7c945cf8"
  end

  resource "smmap" do
    url "https:files.pythonhosted.orgpackages212d39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "stevedore" do
    url "https:files.pythonhosted.orgpackagesacd677387d3fc81f07bc8877e6f29507bd7943569093583b0a07b28cfa286780stevedore-5.1.0.tar.gz"
    sha256 "a54534acf9b89bc7ed264807013b505bf07f74dbe4bcfa37d32bd063870b087c"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesd6af3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages5e5f1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6cwcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  resource "websocket-client" do
    url "https:files.pythonhosted.orgpackagesb1343a5cae1e07d9566ad073fa6d169bf22c03a3ba7b31b3c3422ec88d039108websocket-client-1.6.1.tar.gz"
    sha256 "c951af98631d24f8df89ab1019fc365f2227c0892f12fd150e935607c79dd0dd"
  end

  def install
    virtualenv_install_with_resources
  end

  def caveats
    <<~EOS
      tern requires root privileges so you will need to run `sudo tern`.
      You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    output = if OS.mac?
      shell_output(bin"tern report --image alpine:3.13.5 2>&1", 1)
    else
      shell_output(bin"tern report --image alpine:3.13.5 2>&1")
    end
    assert_match "rootfs - Running command", output
    assert_predicate testpath"tern.log", :exist?

    assert_match version.to_s, shell_output(bin"tern --version")
  end
end