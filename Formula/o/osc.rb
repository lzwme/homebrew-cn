class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https:openbuildservice.org"
  url "https:github.comopenSUSEoscarchiverefstags1.16.0.tar.gz"
  sha256 "42c7d41bbb6e365a65efcb557eee7cded0bb2abeaa30c94877ebc5bc784c1076"
  license "GPL-2.0-or-later"
  revision 1
  head "https:github.comopenSUSEosc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d69ed1cd160424eee722ed24fda796a07d4693a1e1cd17905dee182f9283e33e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "588ecf4c022cbf6ded7fec8b07f973880ff1d371ff97cf5e045eaaf0b111a756"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cfd27ac88ca91b9eb851cd0e8c854d8507bae60ea5824d074a9f68e9da77f02c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6bf4323023018b0e128d34cb78f35a1110fae80a9ae89d1e6ffa74a984d457a4"
    sha256 cellar: :any_skip_relocation, ventura:       "d378d113c590d10ef7a41e41ad3052ea82b6b69db8422d7e6bb7c6cfddc72cf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8cfa9033532ecd4b25ebc248a0c0de5b42ae29d5255dc7e2d95209b2784225cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdd465e79a97c3f19b131ef8f6876167d9983a92c43814902c46ea52262cddde"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https:files.pythonhosted.orgpackagesbdce8db44d2b8fd6713a59e391d12b6816854b7bee8121ae7370c2d565de4265rpm-0.4.0.tar.gz"
    sha256 "79adbefa82318e2625d6e4fa16666cf88543498a1f2c10dc3879165d1dc3ecee"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackages39876da0df742a4684263261c253f00edd5829e6aca970fff69e75028cccc547ruamel.yaml-0.18.14.tar.gz"
    sha256 "7227b76aaec364df15936730efbf7d72b30c0b79b1d578bbb8e3dcb2d81f52b7"
  end

  resource "ruamel-yaml-clib" do
    url "https:files.pythonhosted.orgpackages208480203abff8ea4993a87d823a5f632e4d92831ef75d404c9fc78d0176d2b5ruamel.yaml.clib-0.2.12.tar.gz"
    sha256 "6c8fbb13ec503f99a91901ab46e0b07ae7941cd527393187039aec586fdfd36f"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages15229ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bcurllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_config = testpath"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~INI
      [general]
      apiurl = https:api.opensuse.org

      [https:api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    INI

    output = shell_output("#{bin}osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}osc 2>&1", 2)
  end
end