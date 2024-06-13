class Datasette < Formula
  include Language::Python::Virtualenv
  desc "Open source multi-tool for exploring and publishing data"
  homepage "https:docs.datasette.ioenstable"
  url "https:files.pythonhosted.orgpackagesa657ec9d7317241c40663e8adc0144579ebd0caaea9ecb55ffdfd5bef637d993datasette-0.64.7.tar.gz"
  sha256 "171e11a213eb747302166c6986487e41f6a9a8847a84fef7861bf88bf1b439b9"
  license "Apache-2.0"
  head "https:github.comsimonwdatasette.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a3a44e1824eaa79cfeecb1618c975ba025de9d7ac3a10ddfebd599de90f62d26"
    sha256 cellar: :any,                 arm64_ventura:  "600804defe84c2844714f1662fd3ff848be125a107b199eaeb7ce50370193124"
    sha256 cellar: :any,                 arm64_monterey: "a1f55194396797c37a0e617942f627a37518e64353ebdd7fb88be2ccb7c8e23c"
    sha256 cellar: :any,                 sonoma:         "ccb8f9e59dcf36b9a36c0a470e4f37d14f8cd8a9f1e4fd7f9f1813e62193b584"
    sha256 cellar: :any,                 ventura:        "d187ae236d9b104dc6f1c6524a3b998ff2da418ce262cad0a54108a9844e2067"
    sha256 cellar: :any,                 monterey:       "b0adc947fd42902676b9c4d15f201b2e75c3de4e04faec0c72cd3857516d1c96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0dfc42ae1b3963c4b00183ffd968270cb1125bb5c4135bcfd4d1dc919c82076"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.12"

  resource "aiofiles" do
    url "https:files.pythonhosted.orgpackagesaf41cfed10bc64d774f497a86e5ede9248e1d062db675504b41c320954d99641aiofiles-23.2.1.tar.gz"
    sha256 "84ec2218d8419404abcb9f0c02df3f34c6e0a68ed41072acfb1cef5cbc29051a"
  end

  resource "anyio" do
    url "https:files.pythonhosted.orgpackagese6e3c4c8d473d6780ef1853d630d581f70d655b4f8d7553c6997958c283039a2anyio-4.4.0.tar.gz"
    sha256 "5aadc6a1bbb7cdb0bede386cac5e2940f5e2ff3aa20277e991cf028e0585ce94"
  end

  resource "appdirs" do
    url "https:files.pythonhosted.orgpackagesd7d805696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "asgi-csrf" do
    url "https:files.pythonhosted.orgpackages299c13d880d7ebe13956c037864eb7ac9dbcd0260d4c47844786f07ccca897e1asgi-csrf-0.9.tar.gz"
    sha256 "6e9d3bddaeac1a8fd33b188fe2abc8271f9085ab7be6e1a7f4d3c9df5d7f741a"
  end

  resource "asgiref" do
    url "https:files.pythonhosted.orgpackages2938b3395cc9ad1b56d2ddac9970bc8f4141312dbaec28bc7c218b0dfafd0f42asgiref-3.8.1.tar.gz"
    sha256 "c343bd80a0bec947a9860adb4c432ffa7db769836c64238fc34bdc3fec84d590"
  end

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "click-default-group" do
    url "https:files.pythonhosted.orgpackages1dceedb087fb53de63dad3b36408ca30368f438738098e668b78c87f93cd41dfclick_default_group-1.2.4.tar.gz"
    sha256 "eb3f3c99ec0d456ca6cd2a7f08f7d4e91771bef51b01bdd9580cc6450fe1251e"
  end

  resource "flexcache" do
    url "https:files.pythonhosted.orgpackages55b08a21e330561c65653d010ef112bf38f60890051d244ede197ddaa08e50c1flexcache-0.3.tar.gz"
    sha256 "18743bd5a0621bfe2cf8d519e4c3bfdf57a269c15d1ced3fb4b64e0ff4600656"
  end

  resource "flexparser" do
    url "https:files.pythonhosted.orgpackagesdce4a73612499d9c8c450c8f4878e8bb8b3b2dce4bf671b21dd8d5c6549525a7flexparser-0.3.1.tar.gz"
    sha256 "36f795d82e50f5c9ae2fde1c33f21f88922fdd67b7629550a3cc4d0b40a66856"
  end

  resource "h11" do
    url "https:files.pythonhosted.orgpackagesf5383af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https:files.pythonhosted.orgpackages17b05e8b8674f8d203335a62fdfcfa0d11ebe09e23613c3391033cbba35f7926httpcore-1.0.5.tar.gz"
    sha256 "34a38e2f9291467ee3b44e89dd52615370e152954ba21721378a87b2960f7a61"
  end

  resource "httpx" do
    url "https:files.pythonhosted.orgpackages5c2d3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
  end

  resource "hupper" do
    url "https:files.pythonhosted.orgpackagesbde6bb064537288eee2be97f3e0fcad8e7242bc5bbe9664ae57c7d29b3fa18c2hupper-1.12.1.tar.gz"
    sha256 "06bf54170ff4ecf4c84ad5f188dee3901173ab449c2608ad05b9bfd6b13e32eb"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "itsdangerous" do
    url "https:files.pythonhosted.orgpackages9ccb8ac0172223afbccb63986cc25049b154ecfb5e85932587206f42317be31ditsdangerous-2.2.0.tar.gz"
    sha256 "e0050c0b7da1eea53ffaf149c0cfbb5c6e2e2b69c4bef22c81fa6eb73e5f6173"
  end

  resource "janus" do
    url "https:files.pythonhosted.orgpackagesb8a8facab7275d7d3d2032f375843fe46fad1cfa604a108b5a238638d4615bdcjanus-1.0.0.tar.gz"
    sha256 "df976f2cdcfb034b147a2d51edfc34ff6bfb12d4e2643d3ad0e10de058cb1612"
  end

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesed5539036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5djinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackages875baae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02dMarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  resource "mergedeep" do
    url "https:files.pythonhosted.orgpackages3a41580bb4006e3ed0361b8151a01d324fb03f420815446c7def45d02f74c270mergedeep-1.3.4.tar.gz"
    sha256 "0096d52e9dad9939c3d975a774666af186eda617e6ca84df4c94dec30004f2a8"
  end

  resource "pint" do
    url "https:files.pythonhosted.orgpackages625850fba7e9be4c0503d2b0daab206ccf272f8288b336fed4400c599246f125pint-0.24.tar.gz"
    sha256 "c6c7c027b821413db1ac46b3b7bd296592848b5aec29a88cfc6e378fd1371903"
  end

  resource "pluggy" do
    url "https:files.pythonhosted.orgpackages962d02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  resource "python-multipart" do
    url "https:files.pythonhosted.orgpackages5c0f9c55ac6c84c0336e22a26fa84ca6c51d58d7ac3a2d78b0dfa8748826c883python_multipart-0.0.9.tar.gz"
    sha256 "03f54688c663f1b7977105f021043b0793151e4cb1c1a9d4a11fc13d622c4026"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackagescde5af35f7ea75cf72f2cd079c95ee16797de7cd71f29ea7c68ae5ce7be1eda0PyYAML-6.0.1.tar.gz"
    sha256 "bfdf460b1736c775f2ba9f6a92bca30bc2095067b8a9d77876d1fad6cc3b4a43"
  end

  resource "setuptools" do
    url "https:files.pythonhosted.orgpackagesaa605db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "sniffio" do
    url "https:files.pythonhosted.orgpackagesa287a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbdsniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "typing-extensions" do
    url "https:files.pythonhosted.orgpackagesdfdbf35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "uvicorn" do
    url "https:files.pythonhosted.orgpackages37169f5ccaa1a76e5bfbaa0c67640e2db8a5214ca08d92a1b427fa1677b3da88uvicorn-0.30.1.tar.gz"
    sha256 "d46cd8e0fd80240baffbcd9ec1012a712938754afcf81bce56c024c1656aece8"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin"datasette", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match "15", shell_output("#{bin}datasette --get '_memory.json?sql=select+3*5'")
    assert_match "<title>Datasette:", shell_output("#{bin}datasette --get ''")
  end
end