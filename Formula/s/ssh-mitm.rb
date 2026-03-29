class SshMitm < Formula
  include Language::Python::Virtualenv

  desc "SSH server for security audits and malware analysis"
  homepage "https://docs.ssh-mitm.at"
  url "https://files.pythonhosted.org/packages/f0/4e/c804d08c336bcff29fd665fdc3ff9d3698d529b1d75462b89bc53527862a/ssh_mitm-5.0.1.tar.gz"
  sha256 "221dafeed602c4cca7a3c7fb2eee55eb9725ea11d19a75fd13c9bc3a1cf274ed"
  license "GPL-3.0-only"
  revision 3
  head "https://github.com/ssh-mitm/ssh-mitm.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "80a4fc1fab0bf659bf577c6766156f05237a1c9f5e30daf2cbddb731b1733988"
    sha256 cellar: :any,                 arm64_sequoia: "b6017f81f7da88dbfc9902569f66007a2c8b3367daf9f3cefb6228602846a015"
    sha256 cellar: :any,                 arm64_sonoma:  "464a56d8b777187465d567ce33328828f4c2f584dd810b34f84148a7eaf89bd7"
    sha256 cellar: :any,                 sonoma:        "a1eb64f86acbde813862780fb56136452a8306346ba27516574369a3c35f324c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5f437768af4212478bca40e2b6da9d2e48fc877320da2e2e87760c9b0c9518d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1f411807bfbb63d204b0521fa32883186f478b544ddd8b086a048c9fbdc1abf"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cryptography" => :no_linkage
  depends_on "libsodium" # for pynacl
  depends_on "libyaml"
  depends_on "python@3.14"

  pypi_packages exclude_packages: "cryptography"

  resource "appimage" do
    url "https://files.pythonhosted.org/packages/58/30/625bf3d9cbb7b8736ea053b725bf72e55415cbe5ce4bf4c8971537fb5720/appimage-1.0.0.tar.gz"
    sha256 "75933b9df5cd77dcdc8187fda3142dd84ea63ffc40712369ecc19652ea1ef3ac"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/d4/36/3329e2518d70ad8e2e5817d5a4cac6bba05a47767ec416c7d020a965f408/bcrypt-5.0.0.tar.gz"
    sha256 "f748f7c2d6fd375cc93d3fba7ef4a9e3a092421b8dbf34d8d4dc06be9492dfdd"
  end

  resource "colored" do
    url "https://files.pythonhosted.org/packages/4a/32/b772def12071faf780dd14e8a95ec8eba4bf5934f302de3a3780b919859a/colored-2.3.1.tar.gz"
    sha256 "fe6e888e12dc16643daa0b108f785df6d0b48420084b5d0a567de27bb09a14d8"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/25/ca/8de7744cb3bc966c85430ca2d0fcaeea872507c6a4cf6e007f7fe269ed9d/ecdsa-0.19.2.tar.gz"
    sha256 "62635b0ac1ca2e027f82122b5b81cb706edc38cd91c63dda28e4f3455a2bf930"
  end

  resource "markdown-it-py" do
    url "https://files.pythonhosted.org/packages/5b/f5/4ec618ed16cc4f8fb3b701563655a69816155e79e24a17b651541804721d/markdown_it_py-4.0.0.tar.gz"
    sha256 "cb0a2b4aa34f932c007117b194e945bd74e0ec24133ceb5bac59009cda1cb9f3"
  end

  resource "mdurl" do
    url "https://files.pythonhosted.org/packages/d6/54/cfe61301667036ec958cb99bd3efefba235e65cdeb9c84d24a8293ba1d90/mdurl-0.1.2.tar.gz"
    sha256 "bb413d29f5eea38f31dd4754dd7377d4465116fb207585f97bf925588687c1ba"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/65/ee/299d360cdc32edc7d2cf530f3accf79c4fca01e96ffc950d8a52213bd8e4/packaging-26.0.tar.gz"
    sha256 "00243ae351a257117b6a241061796684b084ed1c516a08c48a3f7e147a9d80b4"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/0b/6a/1d85cc9f5eaf49a769c7128039074bbb8127aba70756f05dfcf4326e72a1/paramiko-3.4.1.tar.gz"
    sha256 "8b15302870af7f6652f2e038975c1d2973f06046cb5d7d65355668b3ecbece0c"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/d9/9a/4019b524b03a13438637b11538c82781a5eda427394380381af8f04f467a/pynacl-1.6.2.tar.gz"
    sha256 "018494d6d696ae03c7e656e5e74cdfd8ea1326962cc401bcf018f1ed8436811c"
  end

  resource "python-json-logger" do
    url "https://files.pythonhosted.org/packages/29/bf/eca6a3d43db1dae7070f70e160ab20b807627ba953663ba07928cdd3dc58/python_json_logger-4.0.0.tar.gz"
    sha256 "f58e68eb46e1faed27e0f574a55a0455eecd7b8a5b88b85a784519ba3cff047f"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/56/db/b8721d71d945e6a8ac63c0fc900b2067181dbb50805958d4d4661cf7d277/pytz-2026.1.post1.tar.gz"
    sha256 "3378dde6a0c3d26719182142c56e60c7f9af7e968076f31aae569d72a0358ee1"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/b3/c6/f3b320c27991c46f43ee9d856302c70dc2d0fb2dba4842ff739d5f46b393/rich-14.3.3.tar.gz"
    sha256 "b8daa0b9e4eef54dd8cf7c86c03713f53241884e814f4e2f5fb342fe520f639b"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "sshpubkeys" do
    url "https://files.pythonhosted.org/packages/a3/b9/e5b76b4089007dcbe9a7e71b1976d3c0f27e7110a95a13daf9620856c220/sshpubkeys-3.3.1.tar.gz"
    sha256 "3020ed4f8c846849299370fbe98ff4157b0ccc1accec105e07cfa9ae4bb55064"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/2e/64/925f213fdcbb9baeb1530449ac71a4d57fc361c053d06bf78d0c5c7cd80c/wrapt-2.1.2.tar.gz"
    sha256 "3996a67eecc2c68fd47b4e3c564405a5777367adfd9b8abb58387b63ee83b21e"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/register-python-argcomplete", "ssh-mitm",
                                         shell_parameter_format: :arg)
  end

  test do
    # supress CryptographyDeprecationWarning warning,
    # upstream bug report https://github.com/ssh-mitm/ssh-mitm/issues/177
    ENV["PYTHONWARNINGS"] = "ignore"

    require "pty"
    port = free_port

    stdout, _stdin, _pid = PTY.spawn("#{bin}/ssh-mitm server --listen-port #{port}")
    assert_match "SSH-MITM - ssh audits made simple", stdout.readline
  end
end