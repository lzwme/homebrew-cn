class WeaviateCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface for managing and interacting with Weaviate"
  homepage "https://pypi.org/project/weaviate-cli/"
  url "https://files.pythonhosted.org/packages/e2/aa/d49ae3e5d399d3bb4026188017220c4dcdd240d64de88df41259056c801a/weaviate_cli-3.0.2.tar.gz"
  sha256 "7a4a3ced248678a6d006ce849edf1d97b15237605f2735bb5ea7882b954c1fdb"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3c9202fdeab0842370016b7529e45022d3b8e9637c41f5d09b814f3a873462d0"
    sha256 cellar: :any,                 arm64_sonoma:  "72b9e448fb259cb00f5a087a909a2c731c4f7fa08ad80939963a37f6d0fcf12f"
    sha256 cellar: :any,                 arm64_ventura: "21c9e63e229aeffadace9fc0a3f3c4a6ce1e94a7bbc4dc77a20763af705db927"
    sha256 cellar: :any,                 sonoma:        "00592cdc69f9dfec1770eb267cb30eed2e4f7be2ea8afc43b366a6bc8aa047be"
    sha256 cellar: :any,                 ventura:       "e7cd0b207eda3fe275433f54762ec7c29c07e22bf92871e8596ceccf2ec5a0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71c8f82451b3e15a5283c1c069ffc72758fbf81898f27d3d8df75b72beae8310"
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

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/f2/4f/e1808dc01273379acc506d18f1504eb2d299bd4131743b9fc54d7be4df1e/charset_normalizer-3.4.0.tar.gz"
    sha256 "223217c3d4f82c3ac5e29032b3f1c2eb0fb591b72161f86d93f5719079dae93e"
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
    url "https://files.pythonhosted.org/packages/5c/2d/3da5bdf4408b8b2800061c339f240c1802f2e82d55e50bd39c5a881f47f0/httpx-0.27.0.tar.gz"
    sha256 "a0cb88a46f32dc874e04ee956e4c2764aba2aa228f650b06788ba6bda2962ab5"
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
    url "https://files.pythonhosted.org/packages/25/ca/1166b75c21abd1da445b97bf1fa2f14f423c6cfb4fc7c4ef31dccf9f6a94/numpy-2.1.3.tar.gz"
    sha256 "aa08e04e08aaf974d4458def539dece0d28146d866a39da5639596f4921fd761"
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

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
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

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/ed/63/22ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260/urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
  end

  resource "validators" do
    url "https://files.pythonhosted.org/packages/64/07/91582d69320f6f6daaf2d8072608a4ad8884683d4840e7e4f3a9dbdcc639/validators-0.34.0.tar.gz"
    sha256 "647fe407b45af9a74d245b943b18e6a816acf4926974278f6dd617778e1e781f"
  end

  resource "weaviate-client" do
    url "https://files.pythonhosted.org/packages/5d/7d/3894d12065d006743271b0b6bcc3bf911910473e91179d5966966816d694/weaviate_client-4.9.6.tar.gz"
    sha256 "56d67c40fc94b0d53e81e0aa4477baaebbf3646fbec26551df66e396a72adcb6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/weaviate-cli --version")
    assert_match "Error: Connection to Weaviate failed.", shell_output("#{bin}/weaviate-cli get collection", 1)
  end
end