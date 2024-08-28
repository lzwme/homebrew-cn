class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https:openbuildservice.org"
  url "https:github.comopenSUSEoscarchiverefstags1.9.1.tar.gz"
  sha256 "2a9a466908190bd65bab047180abb372e30ac1ca06ef2488087d14e36edf1388"
  license "GPL-2.0-or-later"
  head "https:github.comopenSUSEosc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "32fdf1b9d5de5626e133db03159e5a6a4c06357dc9faf3c1f4bbc8997fe9576d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32fdf1b9d5de5626e133db03159e5a6a4c06357dc9faf3c1f4bbc8997fe9576d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32fdf1b9d5de5626e133db03159e5a6a4c06357dc9faf3c1f4bbc8997fe9576d"
    sha256 cellar: :any_skip_relocation, sonoma:         "b440ae8843b0300dfd814393075b27463847bc66a699338134b3fe81b365dd4c"
    sha256 cellar: :any_skip_relocation, ventura:        "b440ae8843b0300dfd814393075b27463847bc66a699338134b3fe81b365dd4c"
    sha256 cellar: :any_skip_relocation, monterey:       "b440ae8843b0300dfd814393075b27463847bc66a699338134b3fe81b365dd4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32fdf1b9d5de5626e133db03159e5a6a4c06357dc9faf3c1f4bbc8997fe9576d"
  end

  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https:files.pythonhosted.orgpackages441bef44b5e2fae8e398bfc58f38c25a6f0a10ea147e3e4970b7e66154017d1drpm-0.2.0.tar.gz"
    sha256 "b92285f65c9ddf77678cb3e51aa67827426408fac34cdd8d537d8c14e3eaffbf"
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