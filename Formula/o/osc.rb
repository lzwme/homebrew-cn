class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https:openbuildservice.org"
  url "https:github.comopenSUSEoscarchiverefstags1.6.1.tar.gz"
  sha256 "da8d0317271335c91780ed397fd61b8d4bafff0e4e8b41f6bf88441e87c78bc8"
  license "GPL-2.0-or-later"
  head "https:github.comopenSUSEosc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d31df62b726772d6d0f275af1865c21a6d1f57490a868895594dcc8d0020704a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30637d0454e8dc9974f0615a05754066082d818b232c17cfbc1e125ed3f91106"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7abcb8364e759b1f5b12ae2b5eb53252a5e5c519268c30bdb704aa63df739fa6"
    sha256 cellar: :any_skip_relocation, sonoma:         "96782269301be588ee15c7128b2b296565bcb8ccdfcd40529e0e6b736fce110b"
    sha256 cellar: :any_skip_relocation, ventura:        "41da6607c020d7082fcf1e0d031033a0855fa1d3f6b866850a4266d260e5dba7"
    sha256 cellar: :any_skip_relocation, monterey:       "933bf96e0e36a5ab09aacad98b0f274325ce978b30b86b17f1617d2d96dc4870"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "508bf16aec2472063bbdbd220157551feab1928005f580d34dde2c7bada50b7f"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  uses_from_macos "curl"

  resource "rpm" do
    url "https:files.pythonhosted.orgpackages8c15ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages36dda6b232f449e1bc71802a5b7950dc3675d32c6dbc2a1bd6d71f065551adb6urllib3-2.1.0.tar.gz"
    sha256 "df7aa8afb0148fa78488e7899b2c59b5f4ffcfa82e6c54ccb9dd37c1d7b52d54"
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