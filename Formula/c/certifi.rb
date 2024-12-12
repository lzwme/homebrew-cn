class Certifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https:github.comcertifipython-certifi"
  url "https:files.pythonhosted.orgpackagesb0ee9b19140fe824b367c04c5e1b369942dd754c4c5462d5674002f75c4dedc1certifi-2024.8.30.tar.gz"
  sha256 "bec941d2aa8195e248a60b31ff9f0558284cf01a52591ceda73ea9afffd69fd9"
  license "MPL-2.0"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "f9369ee71eff19d9072af588bf640947ff6219129ac7fb63fe90a37fbbff9e0c"
  end

  depends_on "python@3.12" => [:build, :test]
  depends_on "python@3.13" => [:build, :test]
  depends_on "ca-certificates"

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    # Avoid difference in generated METADATA files across bottles
    inreplace "README.rst", "usrlocal", HOMEBREW_PREFIX

    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      system python_exe, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."

      # Use brewed ca-certificates PEM file instead of the bundled copy
      site_packages = Language::Python.site_packages("python#{python.version.major_minor}")
      rm prefixsite_packages"certificacert.pem"
      (prefixsite_packages"certifi").install_symlink Formula["ca-certificates"].pkgetc"cert.pem" => "cacert.pem"
    end

    # Revert first inreplace to avoid difference in README.rst across bottles
    inreplace "README.rst", HOMEBREW_PREFIX, "usrlocal"
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec"binpython"
      output = shell_output("#{python_exe} -m certifi").chomp
      assert_equal Formula["ca-certificates"].pkgetc"cert.pem", Pathname(output).realpath
    end
  end
end