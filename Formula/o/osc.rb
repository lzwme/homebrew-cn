class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https:openbuildservice.org"
  url "https:github.comopenSUSEoscarchiverefstags1.14.0.tar.gz"
  sha256 "0f2e7dad5d4377530cd5839a6563889302048316ae403acb1a1e05c75aaa1486"
  license "GPL-2.0-or-later"
  head "https:github.comopenSUSEosc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2fd52b44b0118e525e96fdd0315062f70e2efb4a7bbc3adfb1d5724f4dad3077"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2fd52b44b0118e525e96fdd0315062f70e2efb4a7bbc3adfb1d5724f4dad3077"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2fd52b44b0118e525e96fdd0315062f70e2efb4a7bbc3adfb1d5724f4dad3077"
    sha256 cellar: :any_skip_relocation, sonoma:        "e720725830ea34a621e6bbbf2f5c64ef86b36687735b587f5cf44079609a85a9"
    sha256 cellar: :any_skip_relocation, ventura:       "e720725830ea34a621e6bbbf2f5c64ef86b36687735b587f5cf44079609a85a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2fd52b44b0118e525e96fdd0315062f70e2efb4a7bbc3adfb1d5724f4dad3077"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2fd52b44b0118e525e96fdd0315062f70e2efb4a7bbc3adfb1d5724f4dad3077"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https:files.pythonhosted.orgpackagesd3363dae1ccf058414ee9cc1d39722216db0e0430002ce5008c0b0244f1886fdrpm-0.3.1.tar.gz"
    sha256 "d75c5dcb581f1e9c4f89cb6667e938e944c6e7c17dd96829e1553c39f3a4c961"
  end

  resource "ruamel-yaml" do
    url "https:files.pythonhosted.orgpackagesea46f44d8be06b85bc7c4d8c95d658be2b68f27711f279bf9dd0612a5e4794f5ruamel.yaml-0.18.10.tar.gz"
    sha256 "20c86ab29ac2153f80a428e1254a8adf686d3383df04490514ca3b79a362db58"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackagesaa63e53da845320b757bf29ef6a9062f5c669fe997973f966045cb019c3f4b66urllib3-2.3.0.tar.gz"
    sha256 "f8c5449b3cf0861679ce7e0503c7b44b5ec981bec0d1d3795a07f1ba96f0204d"
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