class PythonPytz < Formula
  desc "Python library for cross platform timezone"
  homepage "https://pythonhosted.org/pytz/"
  url "https://files.pythonhosted.org/packages/69/4f/7bf883f12ad496ecc9514cd9e267b29a68b3e9629661a2bbc24f80eff168/pytz-2023.3.post1.tar.gz"
  sha256 "7b4fddbeb94a1eba4b557da24f19fdf9db575192544270a9101d8509f9f43d7b"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "857613e56384067c24824e4cdbedb2f2814c98954f6720e6244741ad77be20c3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e33230c3b829cd914d847704f7edfd18ccc971bda97faee2d10cf3c91d9f8658"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4dd06ff9e2121f45a07c8adfc51e25875291184ec932253f36b31645a61960e"
    sha256 cellar: :any_skip_relocation, sonoma:         "91ed852537c50f6aff08fdb497f93154ba6a2ed33729d165ab027826ea528359"
    sha256 cellar: :any_skip_relocation, ventura:        "d75d3f25d59a8bdfa550f1aaed56b5a53e2a37e545387e935d5163206513b9d1"
    sha256 cellar: :any_skip_relocation, monterey:       "76b746a66c8a72da047d54b5e3fb787e94cfd1b6c481a804bdc2e21b1ab89c2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5da0563119338b28327b91e871ee05ece76a5233d00ab7b4f5305f34e3392102"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

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
      system python_exe, "-c", "import pytz; print(pytz.timezone('UTC'))"
    end
  end
end