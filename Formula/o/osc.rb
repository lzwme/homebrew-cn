class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://ghproxy.com/https://github.com/openSUSE/osc/archive/refs/tags/1.4.4.tar.gz"
  sha256 "ff2d675bdc569f7d6a6cb4b958307757559810219b7e53aef6b1c12a99f4d599"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd7a18091189f42ca6b7fa79fb115f7455037a7b35935e564e98d238b57ae321"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50f1c8a5ce585c97d2cc10e847a93db86c4cce82308e560412994b6c59a14b80"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad3adba61ec107bcd4f2e414d91883d7ed6a1cbd76d78182ef3da57cb88ec741"
    sha256 cellar: :any_skip_relocation, sonoma:         "fd8c245f5b09baa6d881240d43523f68f3b11bc7f883a30d96c359403d4e4f44"
    sha256 cellar: :any_skip_relocation, ventura:        "cb4cf54577740eed1d4120d8377b502bce921ba4acacf38e18fc87317d9cfb02"
    sha256 cellar: :any_skip_relocation, monterey:       "e6a7ee27190b6118a000eb0aeca5a2cb6004a665c15ef1a55cab2dbbc505b807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76e9b54abb1cd44c6201e94c41c954e3b6d5fde51cb2bcbb2cc48b34fbcdca29"
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