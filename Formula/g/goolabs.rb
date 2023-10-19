class Goolabs < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://files.pythonhosted.org/packages/ce/86/2d3b5bd85311ee3a7ae7a661b3619095431503cd0cae03048c646b700cad/goolabs-0.4.0.tar.gz"
  sha256 "4f768a5b98960c507f5ba4e1ca14d45e3139388669148a2750d415c312281527"
  license "MIT"
  revision 8

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ec2d48ef64de82848734cde06416e318e0e71d226a5c9517d683ef68f3b67820"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d8bf5afd13ac12fe10795c9a04cb75f4586d1661ff92b61cf3591a1e14bf368"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45434838d1d08ab79ec52a6c30be5cc611b4e6bc5f342b5c10ed7ebde214c07c"
    sha256 cellar: :any_skip_relocation, sonoma:         "969fa451d5fec752c6d4bcf063f34fe4e68d65ec1f2de01681f19170bf3c2761"
    sha256 cellar: :any_skip_relocation, ventura:        "89730e6267251c28fe7b536803d865b3f4c773c50810310e95c69246c79f8835"
    sha256 cellar: :any_skip_relocation, monterey:       "fcd0aa599bc30bec9971ab63fd8d62c2c72aa66d63c0e84b232e98c92e8322af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "958887708d216fead50d597c2763e779e38bbb1e66b68c417837a41c1ba1975d"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python@3.12"
  depends_on "six"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/cf/ac/e89b2f2f75f51e9859979b56d2ec162f7f893221975d244d8d5277aa9489/charset-normalizer-3.3.0.tar.gz"
    sha256 "63563193aec44bce707e0c5ca64ff69fa72ed7cf34ce6e11d5127555756fd2f6"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end