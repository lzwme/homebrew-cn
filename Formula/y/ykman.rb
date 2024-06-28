class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https:developers.yubico.comyubikey-manager"
  url "https:files.pythonhosted.orgpackages941a93777ec4776013f0c51b2d5f0c61fec8b7b54d6150a4c22bd6e2b4463d71yubikey_manager-5.5.0.tar.gz"
  sha256 "27a616443f79690a5a74d694c642f15b6c887160a7bd81ae43b624bb325e7662"
  license "BSD-2-Clause"
  head "https:github.comYubicoyubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a385fcf070a568715763ac40916244544f5dab6ef3fc0e0719c4606b553583c0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "43f6e69151f9a696655e65ae5c6fcbbfe5416cf420c6374b04775fb85148d519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a96b77633df74b56da0563a15306e5751c2b1717cce85c15b8f3c604193fc23"
    sha256 cellar: :any_skip_relocation, sonoma:         "42dafea3cdac01c3219ec828c8f00b093066cbef03f14479e753c52d9cf8c6c7"
    sha256 cellar: :any_skip_relocation, ventura:        "2a8fb4ea3ae79eda606af0a4336a15cc9f7ec557dc4c437c1dc7e3ef7c44177c"
    sha256 cellar: :any_skip_relocation, monterey:       "3ffb2a20375d200f5bfead24e76a5090bcb7d5a462a4e8eb54cb43a0a82a19d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf2d316c5d4df5af8be07c921187d80c749b80bf8e6f97a916489dc418762272"
  end

  depends_on "swig" => :build
  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "pcsc-lite"

  # pin pyscard to 2.0.8, upstream bug report, https:github.comLudovicRousseaupyscardissues169

  resource "click" do
    url "https:files.pythonhosted.orgpackages96d3f04c7bfcf5c1862a2a5b845c6b2b360488cf47af55dfa79c98f6a6bf98b5click-8.1.7.tar.gz"
    sha256 "ca9853ad459e787e2192211578cc907e7594e294c7ccc834310722b41b9ca6de"
  end

  resource "fido2" do
    url "https:files.pythonhosted.orgpackages786c79d44841549cc3d95bdfbeaa6bc7b36892c86066b05aac44585c56113819fido2-1.1.3.tar.gz"
    sha256 "26100f226d12ced621ca6198528ce17edf67b78df4287aee1285fee3cd5aa9fc"
  end

  resource "jaraco-classes" do
    url "https:files.pythonhosted.orgpackages06c0ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https:files.pythonhosted.orgpackagesc960e83781b07f9a66d1d102a0459e5028f3a7816fdd0894cba90bee2bbbda14jaraco.context-5.3.0.tar.gz"
    sha256 "c2f67165ce1f9be20f32f650f25d8edfc1646a8aeee48ae06fb35f90763576d2"
  end

  resource "jaraco-functools" do
    url "https:files.pythonhosted.orgpackagesbc66746091bed45b3683d1026cb13b8b7719e11ccc9857b18d29177a18838dc9jaraco_functools-4.0.1.tar.gz"
    sha256 "d33fa765374c0611b52f8b3a795f8900869aa88c84769d4d1746cd68fb28c3e8"
  end

  resource "jeepney" do
    url "https:files.pythonhosted.orgpackagesd6f4154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdfjeepney-0.8.0.tar.gz"
    sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
  end

  resource "keyring" do
    url "https:files.pythonhosted.orgpackages3ee954f232e659f635a000d94cfbca40b9d5d617707593c3d552ec14d3ba27f1keyring-25.2.1.tar.gz"
    sha256 "daaffd42dbda25ddafb1ad5fec4024e5bbcfe424597ca1ca452b299861e49f1b"
  end

  resource "more-itertools" do
    url "https:files.pythonhosted.orgpackages013377f586de725fc990d12dda3d4efca4a41635be0f99a987b9cc3a78364c13more-itertools-10.3.0.tar.gz"
    sha256 "e5d93ef411224fbcef366a6e8ddc4c5781bc6359d43412a65dd5964e46111463"
  end

  resource "pyscard" do
    url "https:files.pythonhosted.orgpackages27f9290e3af3b9cf367d8bc9ffe13f537d26ba37ba93b1eae90777125d22d822pyscard-2.0.8.tar.gz"
    sha256 "2eb16ee0e89ab27759fcb36f032c40a5774ed5926c0e03309837bdeb563a6032"
  end

  resource "secretstorage" do
    url "https:files.pythonhosted.orgpackages53a4f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691SecretStorage-3.3.3.tar.gz"
    sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
  end

  def install
    # Fixes: smartcardscardhelpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}PCSC" if OS.linux?

    virtualenv_install_with_resources
    man1.install "manykman.1"

    # Click doesn't support generating completions for Bash versions older than 4.4
    generate_completions_from_executable(bin"ykman", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ykman --version")
  end
end