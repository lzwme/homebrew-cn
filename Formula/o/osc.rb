class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://files.pythonhosted.org/packages/13/94/6674d6f4955e6c45436fc8cedfc480d2d889bb07006951dd834db84fe28d/osc-1.23.0.tar.gz"
  sha256 "54a6d3d7ffc0d4952c82433394ba05d562538feba56b2d3b611ce103f8e8b724"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1d6396deb2fbbc1233ef0980ea851ba3f162fc1129fa4089133496d4be0cb6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dcaa3ebcf51ed62de6a6128a493ab4e84acbd14fd8b2a5c8634eb6bea1cdf781"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "646ee620734e36e31b7b4bfb0746d3ecbfdd944204a4bf9f41d7e932e985b0c6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d338106ba0e5a0155d4f4d9fa9babc893123cfd50447f6211a16dba36838478"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4c33a12a497773820ac28094e1d8e78dd964906c36f017993b01b0e4f880dea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bd41a271ffec53d78d39567b42c03653a2eedd044515b5c7197de72caf82041"
  end

  depends_on "cryptography" => :no_linkage
  depends_on "python@3.14"
  depends_on "rpm"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  pypi_packages package_name:     "",
                extra_packages:   %w[ruamel-yaml urllib3],
                exclude_packages: "cryptography"

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3a/2b/7a1f1ebcd6b3f14febdc003e658778d81e76b40df2267904ee6b13f0c5c6/ruamel_yaml-0.18.17.tar.gz"
    sha256 "9091cd6e2d93a3a4b157ddb8fabf348c3de7f1fb1381346d985b6b247dcd8d3c"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/ea/97/60fda20e2fb54b83a61ae14648b0817c8f5d84a3821e40bfbdae1437026a/ruamel_yaml_clib-0.2.15.tar.gz"
    sha256 "46e4cc8c43ef6a94885f72512094e482114a8a706d3c555a34ed4b0d20200600"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1e/24/a2a2ed9addd907787d7aa0355ba36a6cadf1768b934c652ea78acbd59dcd/urllib3-2.6.2.tar.gz"
    sha256 "016f9c98bb7e98085cb2b4b17b87d2c702975664e4f060c6532e64d1c1a5e797"
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
    assert_match "Directory '.' is not a Git SCM working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end