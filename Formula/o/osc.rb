class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https:openbuildservice.org"
  url "https:github.comopenSUSEoscarchiverefstags1.5.1.tar.gz"
  sha256 "17b1268413561b3d1b8564d3d1ed8f025efa34774497df4d54205b6cf0882c28"
  license "GPL-2.0-or-later"
  head "https:github.comopenSUSEosc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f06df6182229a4fdd1b9993085ed457dc2adecb92486e3dabfb11b13d405be8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "424d163646a5b78b47e569c856334ae9b78046e87a07bbdde93d0e08603926e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "853d0a71f8f50d491886fcabc13e337565d4d06bd3d4f4b27c8921aaf02c41f3"
    sha256 cellar: :any_skip_relocation, sonoma:         "7311403384575e9612d4515d9e8852ed601fbe1c21d9230fc2fd2918755aaa18"
    sha256 cellar: :any_skip_relocation, ventura:        "c6a7b554110f7d87395b38a45ee81024120df3b879fb780b669511ea49335b2c"
    sha256 cellar: :any_skip_relocation, monterey:       "e3b813737232f817b4cf13a50dc4857ddd0dcfa6225bffbfc9dab9c2b18924bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b829feaa1e869a12c74067ebe4a9f8196df4df98384bb5858911ad79a7efd6"
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