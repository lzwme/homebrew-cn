class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https:openbuildservice.org"
  url "https:github.comopenSUSEoscarchiverefstags1.12.1.tar.gz"
  sha256 "17570bfe80d5937564036e466c2470c4de37697a16902451556e5af81791aab1"
  license "GPL-2.0-or-later"
  head "https:github.comopenSUSEosc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d5bd112951930c20fa1a71db4bfec16490858f49dd51a45bf4e06fa97742790f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d5bd112951930c20fa1a71db4bfec16490858f49dd51a45bf4e06fa97742790f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d5bd112951930c20fa1a71db4bfec16490858f49dd51a45bf4e06fa97742790f"
    sha256 cellar: :any_skip_relocation, sonoma:        "25433f56466b7dd091edf31a00553a99fd6b8390810f6fa8625d21c9ec3f8792"
    sha256 cellar: :any_skip_relocation, ventura:       "25433f56466b7dd091edf31a00553a99fd6b8390810f6fa8625d21c9ec3f8792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5bd112951930c20fa1a71db4bfec16490858f49dd51a45bf4e06fa97742790f"
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