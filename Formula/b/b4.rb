class B4 < Formula
  include Language::Python::Virtualenv

  desc "Tool to work with public-inbox and patch archives"
  homepage "https://b4.docs.kernel.org/en/latest/"
  url "https://files.pythonhosted.org/packages/70/99/2b34c8451ad6599090f7d9045adb9f19270c2ed8cef4d52c179b297f8e37/b4-0.14.3.tar.gz"
  sha256 "31a4927b8dfbb5c97edfc9569cda3b6737bbfd8430881e8cc48a0b088ced6147"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7c810ce1526093844fa9a0af8996696801cc319107cf78e325b6bb1466db7431"
    sha256 cellar: :any,                 arm64_sequoia: "8bf6c65b1fa408e8f3616f2a143f81830693a089babbbb4f0be6cfdafb98d5c1"
    sha256 cellar: :any,                 arm64_sonoma:  "9c78e6b21f7c09f4894c52c3b5f636692af8e19daae9023cf770f9656929361b"
    sha256 cellar: :any,                 sonoma:        "50d0fb0c91c428cc7614e929e2a5f78aeedbb7731b69645c47f709364386c15e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "075ecdb3b53423ea74bcd61457b0f1cbef80c97eb0ddbd397425920530ac8e9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fe6778158e30f2a36de4ad0e0ead5ff1374d30e7913d19138d1273ead7f8456"
  end

  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "libsodium"
  depends_on "python@3.14"

  pypi_packages exclude_packages: ["certifi", "cffi"]

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/13/69/33ddede1939fdd074bce5434295f38fae7136463422fe4fd3e0e89b98062/charset_normalizer-3.4.4.tar.gz"
    sha256 "94537985111c35f28720e43603b8e7b43a6ecfb2ce1d3058bbe955b73404e21a"
  end

  resource "dkimpy" do
    url "https://files.pythonhosted.org/packages/f0/6f/84e91828186bbfcedd7f9385ef5e0d369632444195c20e08951b7ffe0481/dkimpy-1.1.8.tar.gz"
    sha256 "b5f60fb47bbf5d8d762f134bcea0c388eba6b498342a682a21f1686545094b77"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/8c/8b/57666417c0f90f08bcafa776861060426765fdb422eb10212086fb811d26/dnspython-2.8.0.tar.gz"
    sha256 "181d3c6996452cb1189c4046c61599b84a5a86e099562ffde77d26984ff26d0f"
  end

  resource "git-filter-repo" do
    url "https://files.pythonhosted.org/packages/b9/bb/7a283f568af6b0528ade65e8ace84bd6ba46003e429101bcd62c232d01a5/git_filter_repo-2.47.0.tar.gz"
    sha256 "411b27e68a080c07a69c233cb526dbc2d848b09a72f10477f4444dd0822cf290"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/6f/6d/0703ccc57f3a7233505399edb88de3cbd678da106337b9fcde432b65ed60/idna-3.11.tar.gz"
    sha256 "795dafcc9c04ed0c1fb032c2aa73654d8e8c5023a7df64a53f39190ada629902"
  end

  resource "patatt" do
    url "https://files.pythonhosted.org/packages/fa/62/8adfadbc130cd33696e06c9c2f3ea36252c2e3dd1387cfdea0bc3aa10172/patatt-0.6.3.tar.gz"
    sha256 "980826f6529d2576c267ca1f564d5bef046cb47e54215bb598ed6c4b9b2d0a28"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/b2/46/aeca065d227e2265125aea590c9c47fbf5786128c9400ee0eb7c88931f06/pynacl-1.6.1.tar.gz"
    sha256 "8d361dac0309f2b6ad33b349a56cd163c98430d409fa503b10b70b3ad66eaa1d"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/c9/74/b3ff8e6c8446842c3f5c837e9c3dfcfe2018ea6ecef224c710c85ef728f4/requests-2.32.5.tar.gz"
    sha256 "dbba0bac56e100853db0ea71b82b4dfd5fe2bf6d3754a8893c3af500cec7d7cf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/1c/43/554c2569b62f49350597348fc3ac70f786e3c32e7f19d266e19817812dd3/urllib3-2.6.0.tar.gz"
    sha256 "cb9bcef5a4b345d5da5d145dc3e30834f58e8018828cbc724d30b4cb7d4d49f1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/b4 --version")

    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Homebrew
        email = foo@brew.sh
    EOS
    assert_match "No thanks necessary.", shell_output("#{bin}/b4 ty 2>&1")
  end
end