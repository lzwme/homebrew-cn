class WeaviateCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for managing and interacting with Weaviate"
  homepage "https://pypi.org/project/weaviate-cli/"
  url "https://files.pythonhosted.org/packages/37/79/75caf6d526134149bec73797e18ef9ad0a691e1ec931faa4563afbc4291b/weaviate_cli-3.1.0.tar.gz"
  sha256 "3ac08511160d442469cdabd69e30b3285bf4efc93db640caf8e6762c4cad105b"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "6dd619c357043fa50f5ed1f65a418e5a61efdb143763561fa7cf1c06065478e5"
    sha256 cellar: :any,                 arm64_sonoma:  "878f7fcff0597d438c15152833202a5c4b4d1970954bc75314e1a5eb3c18ecdb"
    sha256 cellar: :any,                 arm64_ventura: "bf9b5916ffa470db8a5f670ab72894634e8620535dcfc21fb7cb345b744957cb"
    sha256 cellar: :any,                 sonoma:        "44fa8c2db5d7c231384ebc76757fa842f7ab3e3f6e24dc23b743193a793f73d1"
    sha256 cellar: :any,                 ventura:       "9009c22088311092c3fbec785332fbc0e03cf22d524c1383f33c353c2cbd8e7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa9185e3c2df34b8a81daf9fc6011bff434e61a09edece1877f3e39099d21a18"
  end

  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "certifi"
  depends_on "cryptography"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "libffi"

  on_linux do
    depends_on "patchelf" => :build
  end

  resource "annotated-types" do
    url "https://files.pythonhosted.org/packages/ee/67/531ea369ba64dcff5ec9c3402f9f51bf748cec26dde048a2f973a4eea7f5/annotated_types-0.7.0.tar.gz"
    sha256 "aff07c09a53a08bc8cfccb9c85b05f1aa9a2a6f23728d790723543408344ce89"
  end

  resource "anyio" do
    url "https://files.pythonhosted.org/packages/f6/40/318e58f669b1a9e00f5c4453910682e2d9dd594334539c7b7817dabb765f/anyio-4.7.0.tar.gz"
    sha256 "2f834749c602966b7d456a7567cafcb309f96482b5081d14ac93ccd457f9dd48"
  end

  resource "authlib" do
    url "https://files.pythonhosted.org/packages/09/47/df70ecd34fbf86d69833fe4e25bb9ecbaab995c8e49df726dd416f6bb822/authlib-1.3.1.tar.gz"
    sha256 "7ae843f03c06c5c0debd63c9db91f9fda64fa62a42a77419fa15fbb7e7a58917"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/96/d3/f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5/click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "grpcio" do
    url "https://files.pythonhosted.org/packages/91/ec/b76ff6d86bdfd1737a5ec889394b54c18b1ec3832d91041e25023fbcb67d/grpcio-1.68.1.tar.gz"
    sha256 "44a8502dd5de653ae6a73e2de50a401d84184f0331d0ac3daeb044e66d5c5054"
  end

  resource "grpcio-health-checking" do
    url "https://files.pythonhosted.org/packages/76/96/75b4adad208b3394a0ad6704604a8604e54afdc10f3dd801b73a5d37f7ef/grpcio_health_checking-1.68.1.tar.gz"
    sha256 "ea936cfa0c64a24afd8005873ea61b1acc83a941c00b56a6339c9b225c80a1a8"
  end

  resource "grpcio-tools" do
    url "https://files.pythonhosted.org/packages/2a/2f/d2fc30b79d892050a3c40ef8d17d602f4c6eced066d584621c7bbf195b0e/grpcio_tools-1.68.1.tar.gz"
    sha256 "2413a17ad16c9c821b36e4a67fc64c37b9e4636ab1c3a07778018801378739ba"
  end

  resource "h11" do
    url "https://files.pythonhosted.org/packages/f5/38/3af3d3633a34a3316095b39c8e8fb4853a28a536e55d347bd8d8e9a14b03/h11-0.14.0.tar.gz"
    sha256 "8f19fbbe99e72420ff35c00b27a34cb9937e902a8b810e2c88300c6f0a3b699d"
  end

  resource "httpcore" do
    url "https://files.pythonhosted.org/packages/6a/41/d7d0a89eb493922c37d343b607bc1b5da7f5be7e383740b4753ad8943e90/httpcore-1.0.7.tar.gz"
    sha256 "8551cb62a169ec7162ac7be8d4817d561f60e08eaa485234898414bb5a8a0b4c"
  end

  resource "httpx" do
    url "https://files.pythonhosted.org/packages/b1/df/48c586a5fe32a0f01324ee087459e112ebb7224f646c0b5023f5e79e9956/httpx-0.28.1.tar.gz"
    sha256 "75e98c5f16b0f35b567856f597f06ff2270a374470a5c2392242528e3e3e42fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/f1/70/7703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7d/idna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "importlib-resources" do
    url "https://files.pythonhosted.org/packages/98/be/f3e8c6081b684f176b761e6a2fef02a0be939740ed6f54109a2951d806f3/importlib_resources-6.4.5.tar.gz"
    sha256 "980862a1d16c9e147a59603677fa2aa5fd82b87f223b6cb870695bcfce830065"
  end

  resource "numpy" do
    url "https://files.pythonhosted.org/packages/47/1b/1d565e0f6e156e1522ab564176b8b29d71e13d8caf003a08768df3d5cec5/numpy-2.2.0.tar.gz"
    sha256 "140dd80ff8981a583a60980be1a655068f8adebf7a45a06a6858c873fcdcd4a0"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/d2/4f/1639b7b1633d8fd55f216ba01e21bf2c43384ab25ef3ddb35d85a52033e8/protobuf-5.29.1.tar.gz"
    sha256 "683be02ca21a6ffe80db6dd02c0b5b2892322c59ca57fd6c872d652cb80549cb"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/45/0f/27908242621b14e649a84e62b133de45f84c255eecb350ab02979844a788/pydantic-2.10.3.tar.gz"
    sha256 "cb5ac360ce894ceacd69c403187900a02c4b20b693a9dd1d643e1effab9eadf9"
  end

  resource "pydantic-core" do
    url "https://files.pythonhosted.org/packages/a6/9f/7de1f19b6aea45aeb441838782d68352e71bfa98ee6fa048d5041991b33e/pydantic_core-2.27.1.tar.gz"
    sha256 "62a763352879b84aa31058fc931884055fd75089cccbd9d58bb6afd01141b235"
  end

  resource "semver" do
    url "https://files.pythonhosted.org/packages/41/6c/a536cc008f38fd83b3c1b98ce19ead13b746b5588c9a0cb9dd9f6ea434bc/semver-3.0.2.tar.gz"
    sha256 "6253adb39c70f6e51afed2fa7152bcd414c411286088fb4b9effb133885ab4cc"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/43/54/292f26c208734e9a7f067aea4a7e282c080750c4546559b58e2e45413ca0/setuptools-75.6.0.tar.gz"
    sha256 "8199222558df7c86216af4f84c30e9b34a61d8ba19366cc914424cdbd28252f6"
  end

  resource "sniffio" do
    url "https://files.pythonhosted.org/packages/a2/87/a6771e1546d97e7e041b6ae58d80074f81b7d5121207425c964ddf5cfdbd/sniffio-1.3.1.tar.gz"
    sha256 "f4324edc670a0f49750a81b895f35c3adb843cca46f0530f79fc1babb23789dc"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/df/db/f35a00659bc03fec321ba8bce9420de607a1d37f8342eee1863174c69557/typing_extensions-4.12.2.tar.gz"
    sha256 "1a7ead55c7e559dd4dee8856e3a88b41225abfe1ce8df57b7c13915fe121ffb8"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/64/07/91582d69320f6f6daaf2d8072608a4ad8884683d4840e7e4f3a9dbdcc639/validators-0.34.0.tar.gz"
    sha256 "647fe407b45af9a74d245b943b18e6a816acf4926974278f6dd617778e1e781f"
  end

  resource "weaviate-client" do
    url "https://files.pythonhosted.org/packages/85/b8/b5b2a26e2873f7fe4c11949dbebf57e0fb05928140a928b439fff5f87d80/weaviate_client-4.10.1.tar.gz"
    sha256 "7a1513d0ce7d918100d255224da52fcfe3d0834a2d22069853ab95a2a17f102c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"weaviate-cli", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/weaviate-cli --version")
    assert_match "Error: Connection to Weaviate failed.", shell_output("#{bin}/weaviate-cli get collection", 1)
  end
end