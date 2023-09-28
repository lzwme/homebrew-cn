class Ldeep < Formula
  include Language::Python::Virtualenv

  desc "LDAP enumeration utility"
  homepage "https://github.com/franc-pentest/ldeep"
  url "https://files.pythonhosted.org/packages/97/f6/958336ef1b6b9e69a3fd7405f2230f0e862a13c056b92feb5a5de4db6bcb/ldeep-1.0.35.tar.gz"
  sha256 "6071ce4796f6793f413806c15fff1eb10d3338f709a9dae71a9794b3060fd81d"
  license "MIT"
  head "https://github.com/franc-pentest/ldeep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f1dba80505242cb7649f3d4b7338c09dc7c4841879eaac08bd5c90da8bc88b66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e95022c925924e1e47e149102701250f4d558201220b2250e4fb865d40b69419"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "215b8b7a1ec5dd37f63b702c01af035a3c02a44d16402cf344bf9bf2532df95d"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3d9e42b4c6b4b37da59c0c506c61818625c28e8deedd9c4fd48c25edf9afb1b"
    sha256 cellar: :any_skip_relocation, ventura:        "d7616b4a1bffdda1bbc3b2d46f1cf13d119ce3faf885eab3f8f2ffdb00d91996"
    sha256 cellar: :any_skip_relocation, monterey:       "18998d55a20e0a1d1d107b5c3bf99f365c454654dac17a1dce29bf4db0f72b01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83b6711fca68c33d4ba384817f2a26bb5f8235d42a36a03f51c4290938b09d96"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.11"
  depends_on "six"

  resource "commandparse" do
    url "https://files.pythonhosted.org/packages/79/6b/6f1879101e405e2a5c7d352b340bc97d1936f8d54a8934ae32aac1828e50/commandparse-1.1.2.tar.gz"
    sha256 "4bd7bdd01b52eaa32316d6149a00b4c3820a40ff2ad62476b46aaae65dbe9faa"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "ldap3" do
    url "https://files.pythonhosted.org/packages/43/ac/96bd5464e3edbc61595d0d69989f5d9969ae411866427b2500a8e5b812c0/ldap3-2.9.1.tar.gz"
    sha256 "f3e7fc4718e3f09dda568b57100095e0ce58633bcabbed8667ce3f8fbaa4229f"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/14/c9/09d5df04c9f29ae1b49d0e34c9934646b53bb2131a55e8ed2a0d447c7c53/pycryptodomex-3.19.0.tar.gz"
    sha256 "af83a554b3f077564229865c45af0791be008ac6469ef0098152139e6bd4b5b6"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/ldeep ldap -d brew.ad -s ldap://127.0.0.1:389 enum_users test 2>&1", 1)
    assert_match "[!] Unable to open connection with ldap://127.0.0.1:389", output
  end
end