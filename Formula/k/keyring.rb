class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/70/09/d904a6e96f76ff214be59e7aa6ef7190008f52a0ab6689760a98de0bf37d/keyring-25.6.0.tar.gz"
  sha256 "0b39998aa941431eb3d9b0d4b2460bc773b9df6fed7621c2dfb291a7e0187a66"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4dbce9af56ee9f7c68d4c3cde35b8cabf9d4a6e90576c778199ea444cb727019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4dbce9af56ee9f7c68d4c3cde35b8cabf9d4a6e90576c778199ea444cb727019"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4dbce9af56ee9f7c68d4c3cde35b8cabf9d4a6e90576c778199ea444cb727019"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d5c9a369e0fd7df5245c14574b345dc348e312de4fd3988add42f98400c0d7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d5bcd8c6c0e4b0ff65c69858adb76d8668f434c09497425ec09118addb5271a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d5bcd8c6c0e4b0ff65c69858adb76d8668f434c09497425ec09118addb5271a"
  end

  depends_on "python@3.14"

  on_linux do
    depends_on "cryptography"
  end

  pypi_packages package_name:     "keyring[completion]",
                exclude_packages: "cryptography",
                extra_packages:   %w[jeepney secretstorage]

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/06/c0/ed4a27bc5571b99e3cff68f8a9fa5b56ff7df1c2251cc715a652ddd26402/jaraco.classes-3.4.0.tar.gz"
    sha256 "47a024b51d0239c0dd8c8540c6c7f484be3b8fcf0b2d85c13825780d3b3f3acd"
  end

  resource "jaraco-context" do
    url "https://files.pythonhosted.org/packages/df/ad/f3777b81bf0b6e7bc7514a1656d3e637b2e8e15fab2ce3235730b3e7a4e6/jaraco_context-6.0.1.tar.gz"
    sha256 "9bae4ea555cf0b14938dc0aee7c9f32ed303aa20a3b73e7dc80111628792d1b3"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/f7/ed/1aa2d585304ec07262e1a83a9889880701079dde796ac7b1d1826f40c63d/jaraco_functools-4.3.0.tar.gz"
    sha256 "cfd13ad0dd2c47a3600b439ef72d8615d482cedcff1632930d6f28924d92f294"
  end

  resource "jeepney" do
    url "https://files.pythonhosted.org/packages/7b/6f/357efd7602486741aa73ffc0617fb310a29b588ed0fd69c2399acbb85b0c/jeepney-0.9.0.tar.gz"
    sha256 "cf0e9e845622b81e4a28df94c40345400256ec608d0e55bb8a3feaa9163f5732"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/ea/5d/38b681d3fce7a266dd9ab73c66959406d565b3e85f21d5e66e1181d93721/more_itertools-10.8.0.tar.gz"
    sha256 "f638ddf8a1a0d134181275fb5d58b086ead7c6a72429ad725c67503f13ba30bd"
  end

  resource "secretstorage" do
    url "https://files.pythonhosted.org/packages/31/9f/11ef35cf1027c1339552ea7bfe6aaa74a8516d8b5caf6e7d338daf54fd80/secretstorage-3.4.0.tar.gz"
    sha256 "c46e216d6815aff8a8a18706a2fbfd8d53fcbb0dce99301881687a1b0289ef7c"
  end

  resource "shtab" do
    url "https://files.pythonhosted.org/packages/5a/3e/837067b970c1d2ffa936c72f384a63fdec4e186b74da781e921354a94024/shtab-1.7.2.tar.gz"
    sha256 "8c16673ade76a2d42417f03e57acf239bfb5968e842204c17990cae357d07d6f"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(bin/"keyring", "--print-completion", shells: [:bash, :zsh])
  end

  test do
    assert_empty shell_output("#{bin}/keyring get https://example.com HomebrewTest2", 1)
    assert_match "-F _shtab_keyring",
      shell_output("bash -c 'source #{bash_completion}/keyring && complete -p keyring'")
  end
end