class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package and dependency manager supporting the latest PEP standards"
  homepage "https:pdm.fming.dev"
  url "https:files.pythonhosted.orgpackages49ad4af216d044ac6a3dc0a5e89c801d578a246155050a1ad7b0966b1610609cpdm-2.18.2.tar.gz"
  sha256 "6d93a18d52edca056fafed7b262fe48ddc61984dabf73eb9365ad61a90caebb6"
  license "MIT"
  head "https:github.compdm-projectpdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "29b112c531c1f932dd1feb9e19797464452659b0749233c240439843c2655662"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0208291d2bd3b7d58412d1f0df3c9b373271605e51adc9c56837e56312b2f534"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1566db944809f90b8edec18078b4b99f947805a1807198b2af6a4cb6e1638de7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "00aa50c121b9eb46c0444cb0858bbf45b636c56d5cc4471b0990bdcc6fff2448"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d7db2222d49cb4a8f0bf4abb38cbc5d662d84dbd2bd0db575f1db55d895b8ec"
    sha256 cellar: :any_skip_relocation, ventura:        "7f1da961413e6e312d972ab86d2734c349d36fd006b5597079caa1f2ab98615d"
    sha256 cellar: :any_skip_relocation, monterey:       "b52ebc7c35318980e0e35692c299ca0327f359ecb174805e34062ed3944e8d1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10067909f4340acd7058d18a8cbed79ce507ae581800852d20a74c01b52990bb"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagese6e3c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "blinker" do
    url "https:files.pythonhosted.orgpackages1e57a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abccblinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "dep-logic" do
    url "https:files.pythonhosted.orgpackages61fca9f6af758c26a22fbc104285b73134d24702bbd2e646dcf7c7fa6d4466afdep_logic-0.4.5.tar.gz"
    sha256 "e6e831bb0eb10b200864c482ad6a1c7f08f5c15cdb5909c4dfb8186976368a78"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackagesc491e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackagese6763981447fd369539aba35797db99a8e2ff7ed01d9aa63e9344a31658b8d81filelock-3.16.0.tar.gz"
    sha256 "81de9eb8453c769b63369f87f11131a7ab04e367f8d97ad39dc230daa07e3bec"
  end

  resource "findpython" do
    url "https:files.pythonhosted.orgpackages2957a35de26696baa005ddcfce8af495fb8cdb75942ebebf1cf219a04706fc81findpython-0.6.1.tar.gz"
    sha256 "56e52b409a92bcbd495cf981c85acf137f3b3e51cc769b46eba219bb1ab7533c"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "hishel" do
    url "https:files.pythonhosted.orgpackages8891bf14b25c1fea465299aa1684cf6fab97acb4465d222f4fde457bbea3cf3chishel-0.0.30.tar.gz"
    sha256 "656393ee77e9c39a0d6c527c74810e15d96e598dcb9b191f20a788608ceaca99"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages17b05e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages788208f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagese8ace349c5e6d4543326c6883ee9491e3921e0d07b55fdf3cce184b40d63e72aidna-3.8.tar.gz"
    sha256 "d838c2c0ed6fced7693d5e8ab8e734d5f8fda53a039c0164afb0b82e771e3603"
  end

  resource "installer" do
    url "https:files.pythonhosted.orgpackages0518ceeb4e3ab3aa54495775775b38ae42b10a92f42ce42dfa44da684289b8c8installer-0.7.0.tar.gz"
    sha256 "a26d3e3116289bb08216e0d0f7d925fcef0b0194eedfa0c944bcaaa106c4b631"
  end

  resource "markdown-it-py" do
    url "https:files.pythonhosted.orgpackages38713b932df36c1a044d397a1f92d1cf91ee0a503d91e470cbd670aa66b07ed0markdown-it-py-3.0.0.tar.gz"
    sha256 "e3f60a94fa066dc52ec76661e37c851cb232d92f9886b15cb560aaada2df8feb"
  end

  resource "mdurl" do
    url "https:files.pythonhosted.orgpackagesd654cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "msgpack" do
    url "https:files.pythonhosted.orgpackagescbd07555686ae7ff5731205df1012ede15dd9d927f6227ea151e901c7406af4fmsgpack-1.1.0.tar.gz"
    sha256 "dd432ccc2c72b914e4cb77afce64aab761c1137cc698be3984eee260bcb2896e"
  end

  resource "packaging" do
    url "https:files.pythonhosted.orgpackages516550db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pbs-installer" do
    url "https:files.pythonhosted.orgpackagesa94eaa03c3d932815eb13df230ce621086a345a2f5e9d1ed6703661f48aa4882pbs_installer-2024.8.14.tar.gz"
    sha256 "40144b21f04e90c73f1b79601e139d56d540356630fe473842ea439a59dffaee"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages75a0d7cab8409cdc7d39b037c85ac46d92434fb6595432e069251b38e5c8dd0eplatformdirs-4.3.2.tar.gz"
    sha256 "9e5e27a08aa095dd127b9f2e764d74254f482fef22b0970773bfba79d091ab8c"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyproject-hooks" do
    url "https:files.pythonhosted.orgpackagesc7076f63dda440d4abb191b91dc383b472dae3dd9f37e4c1e4a5c3db150531c6pyproject_hooks-1.1.0.tar.gz"
    sha256 "4b37730834edbd6bd37f26ece6b44802fb1c1ee2ece0e54ddff8bfc06db86965"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesbc57e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "resolvelib" do
    url "https:files.pythonhosted.orgpackagesce10f699366ce577423cbc3df3280063099054c23df70856465080798c6ebad6resolvelib-1.0.1.tar.gz"
    sha256 "04ce76cbd63fded2078ce224785da6ecd42b9564b1390793f64ddecbe997b309"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagescf605959113cae0ce512cf246a6871c623117330105a0d5f59b4e26138f2c9ccrich-13.8.0.tar.gz"
    sha256 "a5ac1f1cd448ade0d59cc3356f7db7a7ccda2c8cbae9c7a90c28ff463d3e91f4"
  end

  resource "shellingham" do
    url "https:files.pythonhosted.orgpackages58158b3609fd3830ef7b27b655beb4b4e9c62313a4e8da8c676e142cc210d58eshellingham-1.5.4.tar.gz"
    sha256 "8dbca0739d487e5bd35ab3ca4b36e11c4078f3a234bfce294b0a0291363404de"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "socksio" do
    url "https:files.pythonhosted.orgpackagesf85c48a7d9495be3d1c651198fd99dbb6ce190e2274d0f28b9051307bdec6b85socksio-1.0.0.tar.gz"
    sha256 "f88beb3da5b5c38b9890469de67d0cb0f9d494b78b106ca1845f96c10b91c4ac"
  end

  resource "tomlkit" do
    url "https:files.pythonhosted.orgpackagesb109a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fatomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  resource "truststore" do
    url "https:files.pythonhosted.orgpackagesdf2e0e21d4c77bc41c588d3d3c87b8f9b32b2338452718cb261d31cbe55eb4d5truststore-0.9.2.tar.gz"
    sha256 "a1dee0d0575ff22d2875476343783a5d64575419974e228f3248772613c3d993"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "unearth" do
    url "https:files.pythonhosted.orgpackagesde1f5664f19db1352460e42f32e39976d8498a0fe056f0495221f53a43599154unearth-0.17.2.tar.gz"
    sha256 "0b8a2afd3476f1ab6155fc579501ac47fffe43547d88a70e5a5b76a7fe6caa2c"
  end

  resource "virtualenv" do
    url "https:files.pythonhosted.orgpackages848a134f65c3d6066153b84fc176c58877acd8165ed0b79a149ff50502597284virtualenv-20.26.4.tar.gz"
    sha256 "c17f4e0f3e6036e9f26700446f85c76ab11df65ff6d8a9cbfad9f71aabfcf23c"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin"pdm", "completion")
  end

  test do
    (testpath"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

      [build-system]
      requires = ["pdm-backend"]
      build-backend = "pdm.backend"
    EOS
    system bin"pdm", "add", "requests==2.31.0"
    assert_match "dependencies = [\n    \"requests==2.31.0\",\n]", (testpath"pyproject.toml").read
    assert_predicate testpath"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath"pdm.lock").read
    output = shell_output("#{bin}pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.31.0", output.strip
  end
end