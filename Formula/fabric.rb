class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/d8/b0/fc6880fd6e24b60ccb5e3e1b673cec847d56b8176311f77c63f542fe9fd4/fabric-3.1.0.tar.gz"
  sha256 "ea1c5ea3956d196b5990ba720cc8ee457fa1b9c6f265ab3b643ff63b05e8970a"
  license "BSD-2-Clause"
  revision 3
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2c7eb542f600277b160d133ee8574623f6f5db34b27337e8abc2ae33074e1bac"
    sha256 cellar: :any,                 arm64_monterey: "20a6aa6f83f9cb440dbd2ffe34ff089b96d9f67d99baf1e5a1238c022beb4da3"
    sha256 cellar: :any,                 arm64_big_sur:  "1975e0d01e9993b56cc3d94329e8aa8419b3a73de5d30479d91bea1eacbc922b"
    sha256 cellar: :any,                 ventura:        "96f7f464e545acbaaf6505f6ed9e24a8f142a63afa3c8a17b543da51007e7d83"
    sha256 cellar: :any,                 monterey:       "b266b404907aa8d4c35eed783288e35d6833e24a3113256cc798e08c607dc56e"
    sha256 cellar: :any,                 big_sur:        "0f20943dccef5b9e5900df698441d2e8fff4b69146679004530fa8d10776d6b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a44298a41c3e71626aa6fdb084e82758d344d33460a4a7c99a0d4cfb8bfe55d"
  end

  # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pyinvoke"
  depends_on "python@3.11"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/8e/5d/2bf54672898375d081cb24b30baeb7793568ae5d958ef781349e9635d1c8/cryptography-41.0.3.tar.gz"
    sha256 "6d192741113ef5e30d89dcb5b956ef4e1578f304708701b8b73d38e3e1461f34"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/44/03/158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6/paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources

    # we depend on pyinvoke, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    pyinvoke = Formula["pyinvoke"].opt_libexec
    (libexec/site_packages/"homebrew-pyinvoke.pth").write pyinvoke/site_packages
  end

  test do
    (testpath/"fabfile.py").write <<~EOS
      from invoke import task
      import fabric
      @task
      def hello(c):
        c.run("echo {}".format(fabric.__version__))
    EOS
    assert_equal version.to_s, shell_output("#{bin}/fab hello").chomp
  end
end