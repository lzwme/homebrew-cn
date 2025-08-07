class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://files.pythonhosted.org/packages/a2/70/274b4097d5b32540607a56c0527a06048007a35bcd7bb1e2b5e0c88f48c9/osc-1.19.1.tar.gz"
  sha256 "81b8da13d1b4ca32fb6e9f73dfad4fa52b393a7e29bac0cc4e536471a741240d"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d57387af026a72b95694381b3b019d130c989fda1d4502626e8da4a8343b378f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "758f75779b3723115c16e5b62e97cf986a3d4cd2a510a5e7644f5b893079c8c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e60c47c61481723867a43258980257046c13bd74e6dc39406c96575674d85535"
    sha256 cellar: :any_skip_relocation, sonoma:        "84aed3b197a8623d34c3cca517140cfb50411364d60f19f4ba265ac99753a08e"
    sha256 cellar: :any_skip_relocation, ventura:       "f5304858b6b47375ae06e0b7e3df2bc2ac2600b3373531bba14c6a95ac102f44"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "be32b1df3efbf5b739f4101816e2a8f950b2f49de3918c8b28b0004a512d8667"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "058e22b91034b003a709407b047a561c7c756f5dbba84c4ee28999860f7f42a8"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/bd/ce/8db44d2b8fd6713a59e391d12b6816854b7bee8121ae7370c2d565de4265/rpm-0.4.0.tar.gz"
    sha256 "79adbefa82318e2625d6e4fa16666cf88543498a1f2c10dc3879165d1dc3ecee"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/39/87/6da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547/ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/20/84/80203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5/ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~INI
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    INI

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end