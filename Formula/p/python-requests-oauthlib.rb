class PythonRequestsOauthlib < Formula
  desc "OAuthlib support for python-requests"
  homepage "https://requests-oauthlib.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/95/52/531ef197b426646f26b53815a7d2a67cb7a331ef098bb276db26a68ac49f/requests-oauthlib-1.3.1.tar.gz"
  sha256 "75beac4a47881eeb94d5ea5d6ad31ef88856affe2332b9aafb52c6452ccf0d7a"
  license "ISC"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d52dbcf8e408d93adb922c794f044e6565abdcd8216f17437fd647f984b91b96"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40023d25c36a4a93d85bc43a832a3f90738b3bd7b2c19558bb45540edd50847d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46e6b829f15ae43616693690c5ecb6e4ce3a50aa7836290794924ba8f431081e"
    sha256 cellar: :any_skip_relocation, sonoma:         "f6aaf863614a9c32b3e3eb4e4c1277c4717f563d1a7758123cff5f6012d9f898"
    sha256 cellar: :any_skip_relocation, ventura:        "cb1b4dba65b85a84b051c693dbe1a13a67de820eb2018d2f9ca6c82f2d742b8b"
    sha256 cellar: :any_skip_relocation, monterey:       "e5604739897d8559eb185121501ba45304ae1a851a6b65a6478c75a2a48be4ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1115c7994150f741f5767237149918be4609fb95f9503cfa06ca6ea00adcc78"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-oauthlib"
  depends_on "python-requests"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "from requests_oauthlib import OAuth1Session"
    end
  end
end