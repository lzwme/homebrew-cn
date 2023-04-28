class CyralGimmeDbToken < Formula
  include Language::Python::Virtualenv

  desc "Eases using Cyral for SSO login to databases"
  homepage "https://cyral.com/docs/connect/repo-connect/#cli-token-retriever-for-sso"
  url "https://files.pythonhosted.org/packages/96/44/1810cb177f63217550a1cb0f38adf5652636167062e78dd6b1fb3207faf5/cyral-gimme-db-token-0.8.1.tar.gz"
  sha256 "7f49ac2410870b895118f39051264ac047d9f6537d7cbdd8828a7627681c8857"
  license "Apache-2.0"

  bottle do
    rebuild 8
    sha256 cellar: :any,                 arm64_ventura:  "36fb4dea738ea933b82c39ec0f4b5a251857d7c40f3ce2414f4774dc651c9574"
    sha256 cellar: :any,                 arm64_monterey: "67556eb641fd2b0a2ea1c650361a05df85a7d44e1e94a6ae36b075dd38fdec85"
    sha256 cellar: :any,                 arm64_big_sur:  "0cc3497c4e926abe461d09c2d4943055ac17bbb8ce6f551694eb42fafecd7e4c"
    sha256 cellar: :any,                 ventura:        "a5c5c83c2150da2fcb11f572de9b4a911bcf3945c44fe64228dde9eb605135fa"
    sha256 cellar: :any,                 monterey:       "1c5434195a774ff7ff7da3a422095a550212c9d7621b85d04b2da0dd3ec7f1b9"
    sha256 cellar: :any,                 big_sur:        "3fe82aaa3ba1abbf2ea5e7a629739a3c8e2e2d7ef4fea6232b6c3e3d83ebcb65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4fd62e5c5de4e8234c453acf61d861bf040b9f488ba6183f7f9ecf8126d2038"
  end

  depends_on "rust" => :build # for cryptography
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "six"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
  end

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/35/25/47bbbc251b85a765f5370409369991028719f380345f389304fc0e137cc3/awscli-1.27.121.tar.gz"
    sha256 "f2c7c759095167874b9084a9a1b921801d57d16baba1357dd208c9533606b899"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/8c/d3/cac011be3a89b877d6c9cbf1ed4c36da0cc948877132fc0ec7a343b6a4dc/botocore-1.29.121.tar.gz"
    sha256 "955c1dd244b6286d9e17dc525d1459a2a74a1c4e519f35006c72f184fbce0760"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/4c/d2/70fc708727b62d55bc24e43cc85f073039023212d482553d853c44e57bdb/requests-2.29.0.tar.gz"
    sha256 "f2e34a75f4749019bb0e3effb66683630e4ffeaf75819fb51bebef1bf5aef059"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  # patch to use latest poetry_core to fix build
  patch :DATA

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LANG"] = "en_US.UTF-8"
    assert_match version.to_s, shell_output("#{bin}/gimme_db_token --version")
    assert_match "There was an error fetching your token.",
      shell_output("#{bin}/gimme_db_token --address localhost --timeout 1")
    assert_match "Error: Invalid value", shell_output("#{bin}/gimme_db_token unsupported 2>&1", 2)
  end
end

__END__
diff --git a/pyproject.toml b/pyproject.toml
index f88b284..e8b5fbd 100644
--- a/pyproject.toml
+++ b/pyproject.toml
@@ -28,6 +28,5 @@ flake8 = "^3.8.4"
 [tool.poetry.scripts]
 gimme_db_token = "gimme_db_token.__main__:run"
 [build-system]
-requires = ["poetry>=0.12"]
-build-backend = "poetry.masonry.api"
-
+requires = ["poetry_core>=1.0.0"]
+build-backend = "poetry.core.masonry.api"