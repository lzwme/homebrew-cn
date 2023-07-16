class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/d8/b0/fc6880fd6e24b60ccb5e3e1b673cec847d56b8176311f77c63f542fe9fd4/fabric-3.1.0.tar.gz"
  sha256 "ea1c5ea3956d196b5990ba720cc8ee457fa1b9c6f265ab3b643ff63b05e8970a"
  license "BSD-2-Clause"
  revision 2
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "86ea126a435790a9e070fedeec75cabcfb9b7047ee15c0f8c72275ec48c5c161"
    sha256 cellar: :any,                 arm64_monterey: "c78340a8f94272360a3252856e0963cdfe6d1e66fc2cdd6d77b090ce6e10237e"
    sha256 cellar: :any,                 arm64_big_sur:  "86d8c7b876e04e7327f3a9f16de271811fe075a2f60c84d464dc2f21d6e2cdb1"
    sha256 cellar: :any,                 ventura:        "70dc9143e740b7e2916a2bdb063b11cc61c793073195449636352a6683aa4f39"
    sha256 cellar: :any,                 monterey:       "d53bf5cea491fa0c531666bec234e159529d7efe535240c0c389a040a718d800"
    sha256 cellar: :any,                 big_sur:        "2a4c7b649d2f0c9d3be4aa41f6db068894675db81b022657f282fc3283ab7d69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6b1e81636327d79bf7a6ced387d1570367084dedfb38b826917bdc07ef22cae"
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
    url "https://files.pythonhosted.org/packages/93/b7/b6b3420a2f027c1067f712eb3aea8653f8ca7490f183f9917879c447139b/cryptography-41.0.2.tar.gz"
    sha256 "7d230bf856164de164ecb615ccc14c7fc6de6906ddd5b491f3af90d3514c925c"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/87/62/cee9551811c846e9735f749dbdf05d4f9f0dbcecd66eae35b5daacf9a117/paramiko-3.2.0.tar.gz"
    sha256 "93cdce625a8a1dc12204439d45033f3261bdb2c201648cfcdc06f9fd0f94ec29"
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