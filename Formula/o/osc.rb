class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://ghproxy.com/https://github.com/openSUSE/osc/archive/1.4.2.tar.gz"
  sha256 "f5990b3f63fd085ff0d10af12581f8b37d65c3fdcdc56b9263fff85adaef2d33"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd42aa9f05a2ab55b54858bc78f79453ccb846d51a9e554d8ecbe3b704310f22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd8c4b5e7f8fedce28aa75aeb065be6d93bac3db553ca42fb36e0095ed16292d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d884095e004cfe2a538e8381ed84becd3b96aadcda12b4761964766ccd035849"
    sha256 cellar: :any_skip_relocation, sonoma:         "62c3c5c9d28f3bb2c09aee5af08d3873a8855818a3ab63f0c004b4264c9c44d0"
    sha256 cellar: :any_skip_relocation, ventura:        "502e42d977678cdbdd35bbf64a200692e2ce1238213a9f719cced69e222e9e47"
    sha256 cellar: :any_skip_relocation, monterey:       "5b6f337735d6706ae46f7fa44c290d256e8823b7572b161322272a7923ea5ab2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5883d0143146396b7bbf4410903784009b535f8ad12d01ee759a1d75a99f967c"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "curl"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/af/47/b215df9f71b4fdba1025fc05a77db2ad243fa0926755a52c5e71659f4e3c/urllib3-2.0.7.tar.gz"
    sha256 "c97dfde1f7bd43a71c8d2a58e369e9b2bf692d1334ea9f9cae55add7d0dd0f84"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~EOS
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    EOS

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end