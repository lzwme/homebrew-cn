class Waybackpy < Formula
  include Language::Python::Virtualenv

  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fc5bf1bce44dc1a46ab6c988f58915c63f8a8709962986987e91c8a255f8603c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a713a2956f37cab4f6c07bda7b18dc86e12936f79d5d91121456aef286add7f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfda64b6d9ac8b3725d9b18122460472973f190f2a27c2be7be453cd6cafb9cd"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b39e29681710a0065b3be726f177ca1840fd887665a5e441889e40479f083cb"
    sha256 cellar: :any_skip_relocation, ventura:        "85621b1ce752de50d387cd8cd69076593cae944eb297a67cfa3eed6b67987397"
    sha256 cellar: :any_skip_relocation, monterey:       "53d35b19c4e49843a6b0d1df1e94bd74a6a2b5f2668e187942a208076fac3146"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0c1aa73ff33f69470a1111d0b90d3d9af70fa55929619f623b0f90624243a74"
  end

  depends_on "python-certifi"
  depends_on "python-click"
  depends_on "python@3.12"

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
    bin.install_symlink libexec/"bin/waybackpy"
  end

  test do
    output = shell_output("#{bin}/waybackpy -o --url https://brew.sh")
    assert_match "20130328163936", output
  end
end