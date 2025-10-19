class Dxpy < Formula
  include Language::Python::Virtualenv

  desc "DNAnexus toolkit utilities and platform API bindings for Python"
  homepage "https://github.com/dnanexus/dx-toolkit"
  url "https://files.pythonhosted.org/packages/5b/e3/137490ecee242c79ac8b8f0f8215d85fe6e33ff7307d91bf0990b30f3303/dxpy-0.399.1.tar.gz"
  sha256 "53511eca434affbb75d7ed9220ddabb09f39e302bf1f298f04bc56e578773c48"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ffad1b3a409acae0d81fdea0df2e701df80071b3ab719188b129d64376841d97"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f188a1929d5e0e567caa707894ed0a942af2d206dbe3ee6dd5cff3e5bab438e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "19aaeee55088b8b4ebba3c65a617f0e29f325e4318c2913175abab5ea6731b32"
    sha256 cellar: :any_skip_relocation, sonoma:        "5cb40fbd716904d4d60008b5066337225f2db2accf8a665bf076b13b146c5abc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9743608a3c0ee9520165f6090e4e309d636780629ad755babfb849f0e6983f41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83f81a61ae6908b2ea3ae10a0114ed0623178dd2c6a3246420379ce245df8f3c"
  end

  depends_on "certifi"
  depends_on "cryptography"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  on_macos do
    depends_on "readline"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/16/0f/861e168fc813c56a78b35f3c30d91c6757d1fd185af1110f1aec784b35d0/argcomplete-3.6.2.tar.gz"
    sha256 "d0519b1bc867f5f4f4713c41ad0aba73a4a5f007449716b16f385f2166dc6adf"
  end

  resource "crc32c" do
    url "https://files.pythonhosted.org/packages/e3/66/7e97aa77af7cf6afbff26e3651b564fe41932599bc2d3dce0b2f73d4829a/crc32c-2.8.tar.gz"
    sha256 "578728964e59c47c356aeeedee6220e021e124b9d3e8631d95d9a5e5f06e261c"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/b3/31/4723d756b59344b643542936e37a31d1d3204bcdc42a7daa8ee9eb06fb50/psutil-7.1.0.tar.gz"
    sha256 "655708b3c069387c8b77b072fc429a57d0e214221d01c0a772df7dfedcb3bcd2"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/66/c0/0c8b6ad9f17a802ee498c46e004a0eb49bc148f2fd230864601a86dcf6db/python-dateutil-2.9.0.post0.tar.gz"
    sha256 "37dd54208da7e1cd875388217d5e00ebd4179249f90fb72437e91a35459a0ad3"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/36/dd/a6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6/urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
  end

  resource "websocket-client" do
    url "https://files.pythonhosted.org/packages/20/07/2a94288afc0f6c9434d6709c5320ee21eaedb2f463ede25ed9cf6feff330/websocket-client-1.7.0.tar.gz"
    sha256 "10e511ea3a8c744631d3bd77e61eb17ed09304c413ad42cf6ddfa4c7787e8fe6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    dxenv = <<~EOS
      API server protocol	https
      API server host		api.dnanexus.com
      API server port		443
      Current workspace	None
      Current folder		None
      Current user		None
    EOS
    assert_match dxenv, shell_output("#{bin}/dx env")
  end
end