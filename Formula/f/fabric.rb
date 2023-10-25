class Fabric < Formula
  include Language::Python::Virtualenv

  desc "Library and command-line tool for SSH"
  homepage "https://www.fabfile.org/"
  url "https://files.pythonhosted.org/packages/0d/3f/337f278b70ba339c618a490f6b8033b7006c583bd197a897f12fbc468c51/fabric-3.2.2.tar.gz"
  sha256 "8783ca42e3b0076f08b26901aac6b9d9b1f19c410074e7accfab902c184ff4a3"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/fabric/fabric.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "11b378c00038fbf0171992d17858d5e9d7fec55483a047502c2d61a24601bfcb"
    sha256 cellar: :any,                 arm64_ventura:  "0ba4c0f22a31cd03f6fe59d4a0a715d79f854b1d30ca0c430f5c25ec26384c8d"
    sha256 cellar: :any,                 arm64_monterey: "78b4be982e8c66db9ae8539f6a9728c09caae9d1ae0380ba98cce11b7fce5a87"
    sha256 cellar: :any,                 sonoma:         "b0570d2dfcdd7102d60e2074c27fe9fdac41e1a0d8aa235c7bc427f6ffb197e2"
    sha256 cellar: :any,                 ventura:        "4013d9617ed2d2dd81f8d757c8cb771846f3e56783cec59c3331b30454c5a61d"
    sha256 cellar: :any,                 monterey:       "aaca4973d5ce8754c8752788bc1b1cf40382d5612a13f19fa101823bc36cfbf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7ba8a7bfa6cce747b2498e19f9547b36a392bf289675c71c3c81d75b6870890"
  end

  depends_on "rust" => :build # for bcrypt
  depends_on "cffi"
  depends_on "pyinvoke"
  depends_on "python-cryptography"
  depends_on "python@3.12"

  resource "bcrypt" do
    url "https://files.pythonhosted.org/packages/8c/ae/3af7d006aacf513975fd1948a6b4d6f8b4a307f8a244e1a3d3774b297aad/bcrypt-4.0.1.tar.gz"
    sha256 "27d375903ac8261cfe4047f6709d16f7d18d39b1ec92aaf72af989552a650ebd"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "deprecated" do
    url "https://files.pythonhosted.org/packages/92/14/1e41f504a246fc224d2ac264c227975427a85caf37c3979979edb9b1b232/Deprecated-1.2.14.tar.gz"
    sha256 "e5323eb936458dccc2582dc6f9c322c852a775a27065ff2b0c4970b9d53d01b3"
  end

  resource "paramiko" do
    url "https://files.pythonhosted.org/packages/44/03/158ae1dcb950bd96f04038502238159e116fafb27addf5df1ba35068f2d6/paramiko-3.3.1.tar.gz"
    sha256 "6a3777a961ac86dbef375c5f5b8d50014a1a96d0fd7f054a43bc880134b0ff77"
  end

  resource "pynacl" do
    url "https://files.pythonhosted.org/packages/a7/22/27582568be639dfe22ddb3902225f91f2f17ceff88ce80e4db396c8986da/PyNaCl-1.5.0.tar.gz"
    sha256 "8ac7448f09ab85811607bdd21ec2464495ac8b7c66d146bf545b0f08fb9220ba"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  def install
    virtualenv_install_with_resources
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