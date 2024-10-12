class VirtManager < Formula
  include Language::Python::Virtualenv

  desc "App for managing virtual machines"
  homepage "https:virt-manager.org"
  url "https:releases.pagure.orgvirt-managervirt-manager-4.1.0.tar.gz"
  sha256 "950681d7b32dc61669278ad94ef31da33109bf6fcf0426ed82dfd7379aa590a2"
  license "GPL-2.0-or-later"
  revision 8
  head "https:github.comvirt-managervirt-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1584e780e4ade6489534849abe65f7b65878b3109b7653f58688707de596807"
  end

  depends_on "docutils" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "adwaita-icon-theme"
  depends_on "certifi"
  depends_on "cpio"
  depends_on "gtk-vnc"
  depends_on "gtksourceview4"
  depends_on "libosinfo"
  depends_on "libvirt-glib"
  depends_on "libvirt-python"
  depends_on "libxml2" # can't use from macos, since we need python3 bindings
  depends_on :macos
  depends_on "osinfo-db"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.13"
  depends_on "spice-gtk"
  depends_on "vte3"

  resource "charset-normalizer" do
    url "https:files.pythonhosted.orgpackages6309c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https:files.pythonhosted.orgpackages21edf86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https:files.pythonhosted.orgpackages63702bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https:files.pythonhosted.orgpackages436dfa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    python3 = "python3.13"
    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    # Restore disabled egg_info command
    inreplace "setup.py", "'install_egg_info': my_egg_info,", ""
    system libexec"binpython", "setup.py", "configure", "--prefix=#{prefix}"
    ENV["PIP_CONFIG_SETTINGS"] = "--global-option=--no-update-icon-cache --no-compile-schemas"
    venv.pip_install_and_link buildpath

    prefix.install libexec"share"
  end

  def post_install
    # manual schema compile step
    system Formula["glib"].opt_bin"glib-compile-schemas", HOMEBREW_PREFIX"shareglib-2.0schemas"
    # manual icon cache update step
    system Formula["gtk+3"].opt_bin"gtk3-update-icon-cache", HOMEBREW_PREFIX"shareiconshicolor"
  end

  test do
    libvirt_pid = fork do
      exec Formula["libvirt"].opt_sbin"libvirtd", "-f", Formula["libvirt"].etc"libvirtlibvirtd.conf"
    end

    output = testpath"virt-manager.log"
    virt_manager_pid = fork do
      $stdout.reopen(output)
      $stderr.reopen(output)
      exec bin"virt-manager", "-c", "test:default", "--debug"
    end
    sleep 10

    assert_match "conn=test:default changed to state=Active", output.read
  ensure
    Process.kill("TERM", libvirt_pid)
    Process.kill("TERM", virt_manager_pid)
    Process.wait(libvirt_pid)
    Process.wait(virt_manager_pid)
  end
end