class Certifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https:github.comcertifipython-certifi"
  url "https:files.pythonhosted.orgpackages0fbd1d41ee578ce09523c81a15426705dd20969f5abf006d1afe8aeff0dd776acertifi-2024.12.14.tar.gz"
  sha256 "b650d30f370c2b724812bee08008be0c4163b163ddaec3f2546c1caf65f191db"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "44725646c779db4d1acc62eb13b8c129bde28644b2a7c0c51c34d3cf3c59ecd0"
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