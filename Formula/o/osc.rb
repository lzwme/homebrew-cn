class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https:openbuildservice.org"
  url "https:github.comopenSUSEoscarchiverefstags1.10.1.tar.gz"
  sha256 "20ee481f7ed9b3355cbdee5f590819b491e9c08992f3f7da0d96ca4495bc68db"
  license "GPL-2.0-or-later"
  head "https:github.comopenSUSEosc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8a4f91c04bacf43e49fb24e8ea1e5ca2c4a7bcf43ef106e7ff4614d21d30249"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8a4f91c04bacf43e49fb24e8ea1e5ca2c4a7bcf43ef106e7ff4614d21d30249"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8a4f91c04bacf43e49fb24e8ea1e5ca2c4a7bcf43ef106e7ff4614d21d30249"
    sha256 cellar: :any_skip_relocation, sonoma:        "af0180709d2e022668a7a2537b7e3d36f60693e465bcb33995b93e20e00ef861"
    sha256 cellar: :any_skip_relocation, ventura:       "af0180709d2e022668a7a2537b7e3d36f60693e465bcb33995b93e20e00ef861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f8a4f91c04bacf43e49fb24e8ea1e5ca2c4a7bcf43ef106e7ff4614d21d30249"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https:files.pythonhosted.orgpackagesd3363dae1ccf058414ee9cc1d39722216db0e0430002ce5008c0b0244f1886fdrpm-0.3.1.tar.gz"
    sha256 "d75c5dcb581f1e9c4f89cb6667e938e944c6e7c17dd96829e1553c39f3a4c961"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesed6322ba4ebfe7430b76388e7cd448d5478814d3032121827c12a2cc287e2260urllib3-2.2.3.tar.gz"
    sha256 "e7d814a81dad81e6caf2ec9fdedb284ecc9c73076b62654547cc64ccdcae26e9"
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