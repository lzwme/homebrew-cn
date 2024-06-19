class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https:openbuildservice.org"
  url "https:github.comopenSUSEoscarchiverefstags1.7.0.tar.gz"
  sha256 "326f8e58ccc12c99a26059a60bd52c0bd3226ad5676224fbfcbf9d53ee248ac4"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.comopenSUSEosc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7002d843aab52352061045e4471e303bf69ad1ae631f924d3223c5892151eb0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7002d843aab52352061045e4471e303bf69ad1ae631f924d3223c5892151eb0f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7002d843aab52352061045e4471e303bf69ad1ae631f924d3223c5892151eb0f"
    sha256 cellar: :any_skip_relocation, sonoma:         "609299d08116b5cb729ea783dba92d5e8784fb6b009430ea27ae3cda3036180f"
    sha256 cellar: :any_skip_relocation, ventura:        "609299d08116b5cb729ea783dba92d5e8784fb6b009430ea27ae3cda3036180f"
    sha256 cellar: :any_skip_relocation, monterey:       "609299d08116b5cb729ea783dba92d5e8784fb6b009430ea27ae3cda3036180f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf4b6cc557186707ed6f144a8d0ad5389103fa604ec095e08e95461fd0f8e4c6"
  end

  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https:files.pythonhosted.orgpackages8c15ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~EOS
      [general]
      apiurl = https:api.opensuse.org

      [https:api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    EOS

    output = shell_output("#{bin}osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}osc 2>&1", 2)
  end
end