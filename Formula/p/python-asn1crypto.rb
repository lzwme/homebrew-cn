class PythonAsn1crypto < Formula
  desc "Python ASN.1 library with a focus on performance"
  homepage "https:github.comwbondasn1crypto"
  url "https:files.pythonhosted.orgpackagesdecfd547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6eeasn1crypto-1.5.1.tar.gz"
  sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f0bcc892a8e3f7ec9b247b48b7c1087849bce6c0eeda3c8771a8e6961f631a61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5fed89cff70dcd5f9ad2f58cdcdb5432cc5f28baab303237b9b086896dee4d66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d5844aa212440c4046f48ae40050976d0bacb4241591a8b5be2eb8365a726ba"
    sha256 cellar: :any_skip_relocation, sonoma:         "f1cf5212abaaea216d83ff4bae67da279e287327d895ab84d9b876af0b8bf1b9"
    sha256 cellar: :any_skip_relocation, ventura:        "feb01d1d5b20c0ae3740e423aae7655643da4fd02a92c432f72d037d9e32ebed"
    sha256 cellar: :any_skip_relocation, monterey:       "f559327b922f7d81f1f9a5dd09e7b9c40db573fed7986c0f11ced21cbc0ece0b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aa70b439380aa5e95301bedf8ecac474e589770e8c2e34c8ac5d843d852d6b6"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-c", "from asn1crypto import pem, x509"
    end
  end
end