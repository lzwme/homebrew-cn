class PythonCertifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/d4/91/c89518dd4fe1f3a4e3f6ab7ff23cb00ef2e8c9adf99dacc618ad5e068e28/certifi-2023.11.17.tar.gz"
  sha256 "9b469f3a900bf28dc19b8cfbf8019bf47f7fdd1a65a1d4ffb98fc14166beb4d1"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e725d4eeae81cf1f8dde8dab4ada86315a2d760c2995f8efd48d5c5e264992eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f79fb464210d1710ee1308d49b29c31e126e7189561cf9ab149afc4f9a6e9b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd46de953e2fff760eada1af1ee10f4f326350f8e660e653c3d15cbe86ef72d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "734371a47c764f08745539dd4babc08e2967db2dc80e822daccf0fe807a6c04f"
    sha256 cellar: :any_skip_relocation, ventura:        "9cf049e969e6f8a424079355957e1dba1a0eedff05dec96c9448d3c060dd9eba"
    sha256 cellar: :any_skip_relocation, monterey:       "6519586d0da1f82c1179883c6dc37081c4dad9a1205e3e0dbcfee55aac7f8cf1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0814e1eb9d0cd05170c07fa532d9406587748bccd6397b1074d573f7adc182d9"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "ca-certificates"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."

      # Use brewed ca-certificates PEM file instead of the bundled copy
      site_packages = Language::Python.site_packages("python#{python.version.major_minor}")
      rm prefix/site_packages/"certifi/cacert.pem"
      (prefix/site_packages/"certifi").install_symlink Formula["ca-certificates"].pkgetc/"cert.pem" => "cacert.pem"
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      output = shell_output("#{python_exe} -m certifi").chomp
      assert_equal Formula["ca-certificates"].pkgetc/"cert.pem", Pathname(output).realpath
    end
  end
end