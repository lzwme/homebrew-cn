class PassImport < Formula
  include Language::Python::Virtualenv

  desc "Pass extension for importing data from most existing password managers"
  homepage "https:github.comroddhjavpass-import"
  url "https:files.pythonhosted.orgpackagesf1691d763287f49eb2d43f14280a1af9f6c2aa54a306071a4723a9723a6fb613pass-import-3.5.tar.gz"
  sha256 "e3e5ec38f58511904a82214f8a80780729dfe84628d7c5d6b1cedee20ff3fb23"
  license "GPL-3.0-or-later"
  revision 4
  head "https:github.comroddhjavpass-import.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "db18ad714373d6ea334b5c030d8854f69ae5e2d4cbce1a55366fbf788001386c"
    sha256 cellar: :any,                 arm64_sonoma:  "2ecbea7df07231767591b191ab87d5e2adb3dbd072213c656ad53ef9c2f22dc3"
    sha256 cellar: :any,                 arm64_ventura: "f084d9c0dff2280645aa06b71b8c3143dbfa19d1821f9f7710e02aa88048c55b"
    sha256 cellar: :any,                 sonoma:        "dec4ea452903371dbfe29baee36e7cea3cb881a3c6727ace07ab4cf4c0da36a7"
    sha256 cellar: :any,                 ventura:       "940425c033875623552ae751a1e1a80af81e49a0ed9cdbb6b8193839f4ecb7bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "607eb970dc38629e48c517360413de962f13c0605cb8273f131cf13290a69c9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85d9db2b932d531631b838650455d9004fd86d21e71879a88c06e1b0b3567e5"
  end

  depends_on "certifi"
  depends_on "libyaml"
  depends_on "python@3.13"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackagese43389c2ced2b67d1c2a61c19c6751aa8902d46ce3dacb23600a283619f5a12dcharset_normalizer-3.4.2.tar.gz"
    sha256 "5baececa9ecba31eff645232d59845c07aa030f0c81ee70184a90d35099a0e63"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackagesf1707703c29685631f5a7590aa73f1f1d3fa9a380e654b86af429e0934a32f7didna-3.10.tar.gz"
    sha256 "12f65c9b470abda6dc35cf8e63cc574b1c52b11df2c86030af0ac09b01b13ea9"
  end

  resource "pyaml" do
    url "https:files.pythonhosted.orgpackagesc14094f10f32ab952c5cca713d9ac9d8b2fdc37392d90eea403823eeac674c24pyaml-25.5.0.tar.gz"
    sha256 "5799560c7b1c9daf35a7a4535f53e2c30323f74cbd7cb4f2e715b16dd681a58a"
  end

  resource "pyyaml" do
    url "https:files.pythonhosted.orgpackages54ed79a089b6be93607fa5cdaedf301d7dfb23af5f25c398d5ead2525b063e17pyyaml-6.0.2.tar.gz"
    sha256 "d584d9ec91ad65861cc08d42e834324ef890a082e591037abe114850ff7bbc3e"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackagese10a929373653770d8a0d7ea76c37de6e41f11eb07559b103b1c02cafb3f7cf8requests-2.32.4.tar.gz"
    sha256 "27d0316682c8a29834d3264820024b62a36942083d52caf2f14c0591336d3422"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages8a7816493d9c386d8e60e442a35feac5e00f0913c0f4b7c217c11e8ec2ff53e0urllib3-2.4.0.tar.gz"
    sha256 "414bc6535b787febd7567804cc015fee39daab8ad86268f1310a9250697de466"
  end

  resource "zxcvbn" do
    url "https:files.pythonhosted.orgpackagesae409366940b1484fd4e9423c8decbbf34a73bf52badb36281e082fe02b57acazxcvbn-4.5.0.tar.gz"
    sha256 "70392c0fff39459d7f55d0211151401e79e76fcc6e2c22b61add62900359c7c1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    importers = shell_output("#{bin}pimport --list-importers")
    assert_match(The \d+ supported password managers are:, importers)

    exporters = shell_output("#{bin}pimport --list-exporters")
    assert_match(The \d+ supported exporter password managers are, exporters)
  end
end