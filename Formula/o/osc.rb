class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://files.pythonhosted.org/packages/11/85/c7fc2a78daeb2ff8faba56a8955fdb06f9edf653799332828584953b4644/osc-1.21.0.tar.gz"
  sha256 "47511ab565af21d4ce7ffb38bfb0cffda6ee453b142b76ca89b8c9240c26e14f"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f152b87efb10bca172e2dc56a42e3937a99b04bc3ac7b002136049cc94ddb2a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6eb5273b91844ad6338556a71440b5dcbfcb41a4e5d49680ef1c49b1fb92d355"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "794684e1ca6f387d65efa0444590aba95830fdd49012ac38324fcd4a939626a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "9b5e6a88fa247943615259f4b571f9ac338d078f0a1c73be31751009628c3f6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8f6b3b8e0a47572dd90a5f409a523f75464184d4cf8075d04b5fc1d68fcf229e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2339eda684ccde9a5a00bf8b9b30b1862fdcdc626485a9e64e86d02ff9d7d2cf"
  end

  depends_on "cryptography"
  depends_on "python@3.13"

  uses_from_macos "curl"
  uses_from_macos "libffi"

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/bd/ce/8db44d2b8fd6713a59e391d12b6816854b7bee8121ae7370c2d565de4265/rpm-0.4.0.tar.gz"
    sha256 "79adbefa82318e2625d6e4fa16666cf88543498a1f2c10dc3879165d1dc3ecee"
  end

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/3e/db/f3950f5e5031b618aae9f423a39bf81a55c148aecd15a34527898e752cf4/ruamel.yaml-0.18.15.tar.gz"
    sha256 "dbfca74b018c4c3fba0b9cc9ee33e53c371194a9000e694995e620490fd40700"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d8/e9/39ec4d4b3f91188fad1842748f67d4e749c77c37e353c4e545052ee8e893/ruamel.yaml.clib-0.2.14.tar.gz"
    sha256 "803f5044b13602d58ea378576dd75aa759f52116a0232608e8fdada4da33752e"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/15/22/9ee70a2574a4f4599c47dd506532914ce044817c7752a79b6a51286319bc/urllib3-2.5.0.tar.gz"
    sha256 "3fc47733c7e419d4bc3f6b3dc2b4f890bb743906a30d56ba4a5bfa4bbff92760"
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