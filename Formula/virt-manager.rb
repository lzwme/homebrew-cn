class VirtManager < Formula
  include Language::Python::Virtualenv

  desc "App for managing virtual machines"
  homepage "https://virt-manager.org/"
  url "https://releases.pagure.org/virt-manager/virt-manager-4.1.0.tar.gz"
  sha256 "950681d7b32dc61669278ad94ef31da33109bf6fcf0426ed82dfd7379aa590a2"
  license "GPL-2.0-or-later"
  revision 4
  head "https://github.com/virt-manager/virt-manager.git", branch: "main"

  bottle do
    rebuild 2
    sha256 cellar: :any, arm64_ventura:  "6b1adfd47084757a53e8fa0c49e4ea31e7eaccefe2233a10952b636d895f02b7"
    sha256 cellar: :any, arm64_monterey: "253b99fd78fcf070dd078dbec71ad2e1b668efc0debc7445e707a013b9be7621"
    sha256 cellar: :any, arm64_big_sur:  "22429b998c1d6fb131293ac77f0ce586b4d8e60188b3408ec73639d999573cb1"
    sha256 cellar: :any, ventura:        "75ff284b2bf04231ca62e224df6540de526a18e6ec7af4343b21150635a348a3"
    sha256 cellar: :any, monterey:       "d90709a81b42742c55cd339fe6f8faf21db57a0b03ba08acabd90d434ceb238f"
    sha256 cellar: :any, big_sur:        "4d34679d93d770a5e824515066cf27d8e617683f904308514e2d9a53cd40a78d"
  end

  depends_on "docutils" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => :build

  depends_on "adwaita-icon-theme"
  depends_on "cpio"
  depends_on "gtk-vnc"
  depends_on "gtksourceview4"
  depends_on "libosinfo"
  depends_on "libvirt-glib"
  depends_on "libxml2" # can't use from macos, since we need python3 bindings
  depends_on :macos
  depends_on "osinfo-db"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"
  depends_on "spice-gtk"
  depends_on "vte3"

  # Resources are for Python `libvirt-python` and `requests` packages

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "libvirt-python" do
    url "https://files.pythonhosted.org/packages/b0/8d/8a0e86d6c2f4f93f33146fc076b26acbdb943b1fdc2abed9fb1f770ddbba/libvirt-python-9.5.0.tar.gz"
    sha256 "8b6ace0810528ec020e121bf1a142c12f786b12c130c7899e9397f0f3a82c392"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  # requests require "urllib3>=1.21.1,<3"
  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/e2/7d/539e6f0cf9f0b95b71dd701a56dae89f768cd39fd8ce0096af3546aeb5a3/urllib3-1.26.16.tar.gz"
    sha256 "8f135f6502756bde6b2a9b28989df5fbe87c9970cecaa69041edcce7f0589b14"
  end

  def install
    python = "python3.11"
    venv = virtualenv_create(libexec, python)
    venv.pip_install resources

    args = Language::Python.setup_install_args(prefix, python)
    args.insert((args.index "install"), "--no-update-icon-cache", "--no-compile-schemas")

    system libexec/"bin/python", "setup.py", "configure", "--prefix=#{prefix}"
    system libexec/"bin/python", *args
  end

  def post_install
    # manual schema compile step
    system Formula["glib"].opt_bin/"glib-compile-schemas", HOMEBREW_PREFIX/"share/glib-2.0/schemas"
    # manual icon cache update step
    system Formula["gtk+3"].opt_bin/"gtk3-update-icon-cache", HOMEBREW_PREFIX/"share/icons/hicolor"
  end

  test do
    libvirt_pid = fork do
      exec Formula["libvirt"].opt_sbin/"libvirtd", "-f", Formula["libvirt"].etc/"libvirt/libvirtd.conf"
    end

    output = testpath/"virt-manager.log"
    virt_manager_pid = fork do
      $stdout.reopen(output)
      $stderr.reopen(output)
      exec bin/"virt-manager", "-c", "test:///default", "--debug"
    end
    sleep 10

    assert_match "conn=test:///default changed to state=Active", output.read
  ensure
    Process.kill("TERM", libvirt_pid)
    Process.kill("TERM", virt_manager_pid)
    Process.wait(libvirt_pid)
    Process.wait(virt_manager_pid)
  end
end