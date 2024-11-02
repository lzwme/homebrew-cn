class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package and dependency manager supporting the latest PEP standards"
  homepage "https:pdm.fming.dev"
  url "https:files.pythonhosted.orgpackages9ee1cc16af47ad95fe4c622cc24bebff58474333f0a13d458d058e2d83d7433fpdm-2.20.0.post1.tar.gz"
  sha256 "e976c9a346ddb5802a53b70295f9ef4b0af617c65400b41764696b0001cdaee3"
  license "MIT"
  head "https:github.compdm-projectpdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "690e55e429a2eaf0c8c9b88fec623b0a227c468a52c006da981998e8068cd927"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "13a7ee757039cca7600fb879442cc93cc6fd11556b4e63479b11b05ea9429e4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a1388025767cccc3fff548c3c2e13c6f8a3aca03b828701e63a11673fb1c4a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a6ca87396e00265b0e49dcf8ff5e4728b4e302701d10212435514f80aab8a67"
    sha256 cellar: :any_skip_relocation, ventura:       "abf2c5aea586ef34caf4fd57d2d255bd9dd900a889de919a962a746220bf68b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da6bcd3af2947b68c9fe0cd3d3e7eedd1288f3f7bac780b424efa2563b875c43"
  end

  depends_on "certifi"
  depends_on "python@3.13"

  resource "anyio" do
    url "https:files.pythonhosted.orgpackages9f0945b9b7a6d4e45c6bcb5bf61d19e3ab87df68e0601fa8c5293de3542546ccanyio-4.6.2.post1.tar.gz"
    sha256 "4c8bc31ccdb51c7f7bd251f51c609e038d63e34219b44aa86e47576389880b4c"
  end

  resource "blinker" do
    url "https:files.pythonhosted.orgpackages1e57a6a1721eff09598fb01f3c7cda070c1b6a0f12d63c83236edf79a440abccblinker-1.8.2.tar.gz"
    sha256 "8f77b09d3bf7c795e969e9486f39c2c5e9c39d4ee07424be2bc594ece9642d83"
  end

  resource "dep-logic" do
    url "https:files.pythonhosted.orgpackages46c6810b34258a5f4be719a74f011e4b6a3bf4fd1fe38a400fe2682f3d87576fdep_logic-0.4.9.tar.gz"
    sha256 "5d455ea2a3da4fea2be6186d886905c57eeeebe3ea7fa967f599cb8e0f01d5c9"
  end

  resource "distlib" do
    url "https:files.pythonhosted.orgpackages0ddd1bec4c5ddb504ca60fc29472f3d27e8d4da1257a854e1d96742f15c1d02ddistlib-0.3.9.tar.gz"
    sha256 "a60f20dea646b8a33f3e7772f74dc0b2d0772d2837ee1342a00645c81edf9403"
  end

  resource "filelock" do
    url "https:files.pythonhosted.orgpackages9ddb3ef5bb276dae18d6ec2124224403d1d67bccdbefc17af4cc8f553e341ab1filelock-3.16.1.tar.gz"
    sha256 "c249fbfcd5db47e5e2d6d62198e565475ee65e4831e2561c8e313fa7eb961435"
  end

  resource "findpython" do
    url "https:files.pythonhosted.orgpackages9e9b5565a5fb78f7f4d06ccbf10c7d4e43321fe24158e0b7750be9dd7db11ca9findpython-0.6.2.tar.gz"
    sha256 "e0c75ba9f35a7f9bb4423eb31bd17358cccf15761b6837317719177aeff46723"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "hishel" do
    url "https:files.pythonhosted.orgpackagescecfd4414a62b77d1f3f58a0d812be20efe4a647fc1e103cec7c9ac559efe576hishel-0.0.33.tar.gz"
    sha256 "ab5b2661d5e2252f305fd0fb20e8c76bfab3ea73458f20f2591c53c37b270089"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackagesb644ed0fa6a17845fb033bd885c03e842f08c1b9406c86a2e60ac1ae1b9206a6httpcore-1.0.6.tar.gz"
    sha256 "73f6dbd6eb8c21bbf7ef8efad555481853f5f6acdeaff1edb0694289269ee17f"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages788208f8c936781f67d9e6b9eeb8a0c8b4e406136ea4c3d1f89a5db71d42e0e6httpx-0.27.2.tar.gz"
    sha256 "f7c2be1d2f3c3c3160d441802406b206c2b76f5947b11115e6df10c6c65e66c2"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
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
    url "https:files.pythonhosted.orgpackagesc5ad7d0db7b85e37a21b0b784756fdc156096c458a16bb8720f240f8d7beee1fpbs_installer-2024.10.16.tar.gz"
    sha256 "d547d9a5bb564791102d138346bff609659c16acc0147fd701755a2eae8f2050"
  end

  resource "platformdirs" do
    url "https:files.pythonhosted.orgpackages13fc128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages8e628336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  resource "pyproject-hooks" do
    url "https:files.pythonhosted.orgpackagese78228175b2414effca1cdac8dc99f76d660e7a4fb0ceefa4b4ab8f5f6742925pyproject_hooks-1.2.0.tar.gz"
    sha256 "1e859bd5c40fae9448642dd871adf459e5e2084186e8d2c2a79a824c970da1f8"
  end

  resource "python-dotenv" do
    url "https:files.pythonhosted.orgpackagesbc57e84d88dfe0aec03b7a2d4327012c1627ab5f03652216c63d49846d7a6c58python-dotenv-1.0.1.tar.gz"
    sha256 "e324ee90a023d808f1959c46bcbc04446a10ced277783dc6ee09987c37ec10ca"
  end

  resource "resolvelib" do
    url "https:files.pythonhosted.orgpackages79e653dc936ddd11353967e5cb7361f537042914745fccfcaa3475505c9ac596resolvelib-1.1.0.tar.gz"
    sha256 "b68591ef748f58c1e2a2ac28d0961b3586ae8b25f60b0ba9a5e4f3d87c1d6a79"
  end

  resource "rich" do
    url "https:files.pythonhosted.orgpackagesd9e9cf9ef5245d835065e6673781dbd4b8911d352fb770d56cf0879cf11b7ee1rich-13.9.3.tar.gz"
    sha256 "bc1e01b899537598cf02579d2b9f4a415104d3fc439313a7a2c165d76557a08e"
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
    url "https:files.pythonhosted.orgpackages01a8cdcf418e067b8ae539012a3f1a51f90b30b26f5e1952a8f60304396babbctruststore-0.10.0.tar.gz"
    sha256 "5da347c665714fdfbd46f738c823fe9f0d8775e41ac5fb94f325749091187896"
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
    url "https:files.pythonhosted.orgpackages8cb37b6a79c5c8cf6d90ea681310e169cf2db2884f4d583d16c6e1d5a75a4e04virtualenv-20.27.1.tar.gz"
    sha256 "142c6be10212543b32c6c45d3d3893dff89112cc588b7d0879ae5a1ec03a47ba"
  end

  def install
    virtualenv_install_with_resources
    generate_completions_from_executable(bin"pdm", "completion")
  end

  test do
    (testpath"pyproject.toml").write <<~TOML
      [project]
      name = "testproj"
      requires-python = ">=3.9"
      version = "1.0"
      license = {text = "MIT"}

      [build-system]
      requires = ["pdm-backend"]
      build-backend = "pdm.backend"
    TOML
    system bin"pdm", "add", "requests==2.31.0"
    assert_match "dependencies = [\"requests==2.31.0\"]", (testpath"pyproject.toml").read
    assert_predicate testpath"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath"pdm.lock").read
    output = shell_output("#{bin}pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.31.0", output.strip
  end
end