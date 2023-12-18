class Watson < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool to track (your) time"
  homepage "https:tailordev.github.ioWatson"
  url "https:files.pythonhosted.orgpackagesa961868892a19ad9f7e74f9821c259702c3630138ece45bab271e876b24bb381td-watson-2.1.0.tar.gz"
  sha256 "204384dc04653e0dbe8f833243bb833beda3d79b387fe173bfd33faecdd087c8"
  license "MIT"
  revision 3
  head "https:github.comTailorDevWatson.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "94e684e89229c5bcf3989fd27d82918f6245d71761e32bf597e27ba9b7218b21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "02c61d18705e7917e29fa6cb57a72ef49169d1cf2bbb91b640d8a6be403205b7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4cbb1cfea5c4efa4d80da227824f11e4258e650a92f0b2fd52c6d259a798d42b"
    sha256 cellar: :any_skip_relocation, sonoma:         "3250c2a199deb50ce04f87e550f4dd64865920074b633b5313e0890e0636f6fc"
    sha256 cellar: :any_skip_relocation, ventura:        "65d5a97a8f94742aa7224530d97b16d9ebd303f86d43ef99de546a457175f7c5"
    sha256 cellar: :any_skip_relocation, monterey:       "dd7bc67a9e037b5645cd043e949941f756db476f7bc0dbc942d1415124ca6ac8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32116f47634b4e0c3c4ed02992ca592fe80c7e8aa32d05008f976f52a1175467"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python-dateutil"
  depends_on "python@3.12"
  depends_on "six"

  resource "arrow" do
    url "https:files.pythonhosted.orgpackages2e000f6e8fcdb23ea632c866620cc872729ff43ed91d284c866b515c6342b173arrow-1.3.0.tar.gz"
    sha256 "d4540617648cb5f895730f1ad8c82a65f2dad0166f57b75f3ca54759c4d67a85"
  end

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagescface89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "click-didyoumean" do
    url "https:files.pythonhosted.orgpackages2fa7822fbc659be70dcb75a91fb91fec718b653326697d0e9907f4f90114b34fclick-didyoumean-0.3.0.tar.gz"
    sha256 "f184f0d851d96b6d29297354ed981b7dd71df7ff500d82fa6d11f0856bee8035"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages8be143beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages9dbe10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "types-python-dateutil" do
    url "https:files.pythonhosted.orgpackages1b2df189e5c03c22700c4ce5aece4b51bb73fa8adcfd7848629de0fb78af5f6ftypes-python-dateutil-2.8.19.14.tar.gz"
    sha256 "1f4f10ac98bb8b16ade9dbee3518d9ace017821d94b057a425b069f834737f4b"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaf47b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3curllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources

    bash_completion.install "watson.completion" => "watson"
    zsh_completion.install "watson.zsh-completion" => "_watson"
  end

  test do
    system "#{bin}watson", "start", "foo", "+bar"
    system "#{bin}watson", "status"
    system "#{bin}watson", "stop"
    system "#{bin}watson", "log"
  end
end