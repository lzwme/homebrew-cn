class B2Tools < Formula
  include Language::Python::Virtualenv

  desc "B2 Cloud Storage Command-Line Tools"
  homepage "https://github.com/Backblaze/B2_Command_Line_Tool"
  url "https://files.pythonhosted.org/packages/35/74/0fab7c98aa690cac877a87efa3245b32ffcaf9e9a8311deffd3d3c07e560/b2-3.9.0.tar.gz"
  sha256 "67d2d06a95a5d336e5700c8c39f2a19f9fced47ebeb668223d07c0076e358ea5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b56cbefe1369855655cb5f8bd95c8fb0b361938ddaaad2ea059ea61232091b67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "909bedebbf47f48dd3cda8340724d9fa5f77b83212a72216ba403de723c72dac"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9a563e9d07765c02b7c53604eac27fe2f0f74103747a1b89c8e7f19566498f70"
    sha256 cellar: :any_skip_relocation, ventura:        "fb549a5d721ae1284548f3c52dae3700e75ebc582b10212f90475bd1fb90c793"
    sha256 cellar: :any_skip_relocation, monterey:       "17deb4f29d64a8736761fe0c5ffb32c4d1060fbc88f4696ad2269e9db838f6b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "5eaa34a1e2cab7edf01996e94f6a6d0087ed6477c37c4abe13ee799239d2b438"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ad1736be9768acaa78e5ff2f008f7144d96512f0bcb98bcc1807f709eecaac6"
  end

  depends_on "python@3.11"
  depends_on "six"

  conflicts_with "boost-build", because: "both install `b2` binaries"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/42/cd/fdb872d826b76b65b23147e83b1ca4c033445bbff59f8836a118657dd050/argcomplete-3.0.8.tar.gz"
    sha256 "b9ca96448e14fa459d7450a4ab5a22bbf9cee4ba7adddf03e65c398b5daeea28"
  end

  resource "arrow" do
    url "https://files.pythonhosted.org/packages/7f/c0/c601ea7811f422700ef809f167683899cdfddec5aa3f83597edf97349962/arrow-1.2.3.tar.gz"
    sha256 "3934b30ca1b9f292376d9db15b19446088d12ec58629bc3f0da28fd55fb633a1"
  end

  resource "b2sdk" do
    url "https://files.pythonhosted.org/packages/bd/50/1f60ed5b74e3ded185b6827f804637d908ab498549ee8ba30c375a7b5925/b2sdk-1.21.0.tar.gz"
    sha256 "c6b362c1ddc777748ff68fee0b9155fcdf32efb0b6731bf648340483c1ff202b"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/6b/5c/330ea8d383eb2ce973df34d1239b3b21e91cd8c865d21ff82902d952f91f/docutils-0.19.tar.gz"
    sha256 "33995a6753c30b7f577febfc2c50411fec6aac7f7ffeb7c4cfe5991072dcf9e6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "logfury" do
    url "https://files.pythonhosted.org/packages/90/f2/24389d99f861dd65753fc5a56e2672339ec1b078da5e2f4b174d0767b132/logfury-1.0.1.tar.gz"
    sha256 "130a5daceab9ad534924252ddf70482aa2c96662b3a3825a7d30981d03b76a26"
  end

  resource "phx-class-registry" do
    url "https://files.pythonhosted.org/packages/e7/9f/5a7a4d4c414b074df216824068cf8d82a05f05829e11976217cb9e550f50/phx-class-registry-4.0.6.tar.gz"
    sha256 "66e9818de0a9d62e8cfe311587fcd3853ba941b71c11a7a73e5808d6550db125"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/4c/d2/70fc708727b62d55bc24e43cc85f073039023212d482553d853c44e57bdb/requests-2.29.0.tar.gz"
    sha256 "f2e34a75f4749019bb0e3effb66683630e4ffeaf75819fb51bebef1bf5aef059"
  end

  resource "rst2ansi" do
    url "https://files.pythonhosted.org/packages/3c/19/b29bc04524e7d1dbde13272fbb67e45a8eb24bb6d112cf10c46162b350d7/rst2ansi-0.1.5.tar.gz"
    sha256 "1b17fb9a628d40f57933ad1a3aa952346444be069469508e73e95060da33fe6f"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"b2", "install-autocomplete", shell_parameter_format: :arg,
                                                                           shells:                 [:bash])
    pkgshare.install (buildpath/"contrib").children
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    cmd = "#{bin}/b2 authorize_account BOGUSACCTID BOGUSAPPKEY 2>&1"
    assert_match "unable to authorize account", shell_output(cmd, 1)
  end
end