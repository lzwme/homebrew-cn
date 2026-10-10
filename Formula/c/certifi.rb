class Certifi < Formula
  desc "Mozilla CA bundle for Python"
  homepage "https://github.com/certifi/python-certifi"
  url "https://files.pythonhosted.org/packages/a3/c2/24167ea9858356b47a87a50d39908bfdb72ceeefe0041586e704e5376b3a/certifi-2026.7.22.tar.gz"
  sha256 "741e2c3b351ddf169a738da9f2c048608ff7f2c5cc02f1ebc6b118bb090d5d55"
  license "MPL-2.0"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "cd9ca0801f7e87aeef9ec71190deb2304bd797df9532d7b06618f0436054cd58"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "ca-certificates" => :no_linkage

  deny_network_access!

  def install
    system python3, "-m", "pip", "install", *std_pip_args, "."

    # Use brewed ca-certificates PEM file instead of the bundled copy
    site_packages = prefix/Language::Python.site_packages(python3)
    rm site_packages/"certifi/cacert.pem"
    (site_packages/"certifi").install_symlink Formula["ca-certificates"].pkgetc/"cert.pem" => "cacert.pem"

    # Add symlinks to use on all externally-managed pythons
    extra_pythons = Keg.for(python3).to_formula.versioned_formulae.select { |f| f.version >= "3.12" }
    extra_site_packages_list = extra_pythons.map { |f| lib/"python#{f.version.major_minor}/site-packages" }
    extra_site_packages_list << (lib/"python#{Formula["python-freethreading"].version.major_minor}t/site-packages")
    site_packages.find.select(&:file?).each do |path|
      extra_site_packages_list.each do |extra_site_packages|
        (extra_site_packages/path.relative_path_from(site_packages)).dirname.install_symlink path
      end
    end
  end

  test do
    output = shell_output("#{python3} -m certifi").chomp
    assert_equal Formula["ca-certificates"].pkgetc/"cert.pem", Pathname(output).realpath

    # Check that the wheel is safe to use on all pythons
    wheel = prefix/Language::Python.site_packages(python3)/"certifi-#{version}.dist-info/WHEEL"
    assert_match(/^Tag: py3-none-any$/, wheel.read)
  end
end