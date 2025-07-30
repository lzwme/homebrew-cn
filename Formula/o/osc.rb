class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://files.pythonhosted.org/packages/b5/90/39664d958752b4f5b3dd88dad48f40761055cb8c375c323a5b33fe33574b/osc-1.19.0.tar.gz"
  sha256 "cfd925c44cca00df1ad2d31279ca95c8c6e924d47cf46e73d7785d23d6bd1b1f"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f8ad35ce39ea8bf75a055c6b9bbeeb396505509cb9afe5a7a69245e4e5e317d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "477fb547065abbeecaab1ab25f648822ac0d9bd1b395aaa533172e1c8df53269"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "212413b8e4b2079f3623cf0b181d5a00b06b4deecdd58d09dff3f64b9dc86db9"
    sha256 cellar: :any_skip_relocation, sonoma:        "d08c83575d6f584ef22c5898499b10e73b04a558d66475f4d4cdeb5b071ed051"
    sha256 cellar: :any_skip_relocation, ventura:       "a4e3081bfab17054321ce30960547278f439ea012c30744f65ae94a41b08b65b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42cfcf1f63abc35dc5bcd520637a46a84845d2e011467339b8b42168731abc54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7760d406fe95ff1f7b271287640e945247c2012d81ba59acb9bf026b6cb99d6"
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