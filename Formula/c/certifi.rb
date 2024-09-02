class Certifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https:github.comcertifipython-certifi"
  url "https:files.pythonhosted.orgpackagesb0ee9b19140fe824b367c04c5e1b369942dd754c4c5462d5674002f75c4dedc1certifi-2024.8.30.tar.gz"
  sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c109e2f1cbdb2c868d964f8eb4816e865ffacbf9c7d187865ac9e4b729557448"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c109e2f1cbdb2c868d964f8eb4816e865ffacbf9c7d187865ac9e4b729557448"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c109e2f1cbdb2c868d964f8eb4816e865ffacbf9c7d187865ac9e4b729557448"
    sha256 cellar: :any_skip_relocation, sonoma:         "b72c41cf69a1e7317f9994e6f0dbdf1abb3ada5d767db3c10d2b4ac63d1245d4"
    sha256 cellar: :any_skip_relocation, ventura:        "b72c41cf69a1e7317f9994e6f0dbdf1abb3ada5d767db3c10d2b4ac63d1245d4"
    sha256 cellar: :any_skip_relocation, monterey:       "b72c41cf69a1e7317f9994e6f0dbdf1abb3ada5d767db3c10d2b4ac63d1245d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c109e2f1cbdb2c868d964f8eb4816e865ffacbf9c7d187865ac9e4b729557448"
  end

  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]
  depends_on "ca-certificates"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

      # Use brewed ca-certificates PEM file instead of the bundled copy
      site_packages = Language::Python.site_packages("python#{python.version.major_minor}")
      rm prefixsite_packages"certificacert.pem"
      (prefixsite_packages"certifi").install_symlink Formula["ca-certificates"].pkgetc"cert.pem" => "cacert.pem"
    end
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      output = shell_output("#{python_exe} -m certifi").chomp
      assert_equal Formula["ca-certificates"].pkgetc"cert.pem", Pathname(output).realpath
    end
  end
end