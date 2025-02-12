class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https:xon.sh"
  url "https:files.pythonhosted.orgpackages684e56e95a5e607eb3b0da37396f87cde70588efc8ef819ab16f02d5b8378dc4xonsh-0.19.2.tar.gz"
  sha256 "cfdd0680d954a2c3aefd6caddcc7143a3d06aa417ed18365a08219bb71b960b0"
  license "BSD-2-Clause-Views"
  head "https:github.comxonshxonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "080e18423408239801215954550b1cb86e65f14343993dc4e8fe6391320be52c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6346784eb8c198c06ee46003bf1c942f404ac19d1719db3f2100096ae6de14f4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5c314746e35b2e34fff7c1e63dbb8a168d087fed1e96bfea5a1b97daea7efe15"
    sha256 cellar: :any_skip_relocation, sonoma:        "50ea3a9d5cda0233ae57ac8e825ec5b47b3146f6aa8a974a1a58f8a39dee2f28"
    sha256 cellar: :any_skip_relocation, ventura:       "62e22d2e3a2d94dd60cf7b94bdd86c7e0af95194e46711d35aaff4d30e2913a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a80dc8377caa160027b0a9566a64c1c76eac4c48c9512526e64d4dd2c94a6c7b"
  end

  depends_on "python@3.13"

  resource "prompt-toolkit" do
    url "https:files.pythonhosted.orgpackagesa1e1bd15cb8ffdcfeeb2bdc215de3c3cffca11408d829e4b8416dcfe71ba8854prompt_toolkit-3.0.50.tar.gz"
    sha256 "544748f3860a2623ca5cd6d2795e7a14f3d0e1c3c9728359013f79877fc89bab"
  end

  resource "pygments" do
    url "https:files.pythonhosted.orgpackages7c2dc3338d48ea6cc0feb8446d8e6937e1408088a72a39937982cc6111d17f84pygments-2.19.1.tar.gz"
    sha256 "61c16d2a8576dc0649d9f39e089b5f02bcd27fba10d8fb4dcc28173f7a45151f"
  end

  resource "pyperclip" do
    url "https:files.pythonhosted.orgpackages30232f0a3efc4d6a32f3b63cdff36cd398d9701d26cda58e3ab97ac79fb5e60dpyperclip-1.9.0.tar.gz"
    sha256 "b7de0142ddc81bfc5c7507eea19da920b92252b548b96186caf94a5e2527d310"
  end

  resource "setproctitle" do
    url "https:files.pythonhosted.orgpackagesae4eb09341b19b9ceb8b4c67298ab4a08ef7a4abdd3016c7bb152e9b6379031dsetproctitle-1.3.4.tar.gz"
    sha256 "3b40d32a3e1f04e94231ed6dfee0da9e43b4f9c6b5450d53e6dd7754c34e0c50"
  end

  resource "wcwidth" do
    url "https:files.pythonhosted.orgpackages6c6353559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}xonsh -c 2+2")
  end
end