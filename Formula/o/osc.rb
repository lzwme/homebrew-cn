class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https:openbuildservice.org"
  url "https:github.comopenSUSEoscarchiverefstags1.8.1.tar.gz"
  sha256 "f4954b294d919cafdebcaee5036bceefc5b7ba532c1bf1b1c6952d859fecb8f6"
  license "GPL-2.0-or-later"
  head "https:github.comopenSUSEosc.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eaadc0a41578ed333ec392d6dd78754f1c2f9063a2ebf360bffbaf9594b10d77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eaadc0a41578ed333ec392d6dd78754f1c2f9063a2ebf360bffbaf9594b10d77"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eaadc0a41578ed333ec392d6dd78754f1c2f9063a2ebf360bffbaf9594b10d77"
    sha256 cellar: :any_skip_relocation, sonoma:         "7ab032d69264b6b3a2d2a46ab978ca021c7c2d32ad01ead9d2b0d0fee63dc0f9"
    sha256 cellar: :any_skip_relocation, ventura:        "7ab032d69264b6b3a2d2a46ab978ca021c7c2d32ad01ead9d2b0d0fee63dc0f9"
    sha256 cellar: :any_skip_relocation, monterey:       "7ab032d69264b6b3a2d2a46ab978ca021c7c2d32ad01ead9d2b0d0fee63dc0f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6aa3079576d19d49ff56bc418278027599ab1af4278eabb21d464395f1576b71"
  end

  depends_on "cryptography"
  depends_on "python@3.12"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https:files.pythonhosted.orgpackages8c15ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
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