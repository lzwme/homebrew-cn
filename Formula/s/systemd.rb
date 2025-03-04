class Systemd < Formula
  include Language::Python::Virtualenv

  desc "System and service manager"
  homepage "https:systemd.io"
  url "https:github.comsystemdsystemdarchiverefstagsv257.3.tar.gz"
  sha256 "99365d1a01bcc59a659ab59c7bae9c34f7eb2998f1656ee0a4aae05312eacdc9"
  license all_of: [
    # Main license is LGPL-2.1-or-later while systemd-udevd is GPL-2.0-or-later
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    # The remaining licenses encompass various exceptions as defined using
    # file-specific SPDX-License-Identifier. Note that we exclude:
    # 1. "BSD-3-Clause" - it is for an unused build script (gen_autosuspend_rules.py)
    # 2. "OFL-1.1" - we do not install HTML documentation
    "CC0-1.0",
    "LGPL-2.0-or-later",
    "MIT",
    "MIT-0",
    :public_domain,
    { "LGPL-2.0-or-later" => { with: "Linux-syscall-note" } },
    { "GPL-1.0-or-later" => { with: "Linux-syscall-note" } },
    { "GPL-2.0-or-later" => { with: "Linux-syscall-note" } },
    { "GPL-2.0-only" => { with: "Linux-syscall-note" } },
    { any_of: ["BSD-3-Clause", "GPL-2.0-only" => { with: "Linux-syscall-note" }] },
    { any_of: ["MIT", "GPL-2.0-only" => { with: "Linux-syscall-note" }] },
    { any_of: ["MIT", "GPL-2.0-or-later" => { with: "Linux-syscall-note" }] },
    { any_of: ["GPL-2.0-only", "BSD-2-Clause"] },
  ]
  head "https:github.comsystemdsystemd.git", branch: "main"

  bottle do
    sha256 x86_64_linux: "06bb06a6a612764a2fcde5fabdc38a27adb34fe03816538ea18671c6a8c77312"
  end

  depends_on "coreutils" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gperf" => :build
  depends_on "icu4c@76" => :build # FIXME: brew should add to PKG_CONFIG_PATH as dependency of libxml2
  depends_on "libxml2" => :build
  depends_on "libxslt" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "glib"
  depends_on "libcap"
  depends_on "libxcrypt"
  depends_on :linux
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "util-linux" # for libmount
  depends_on "xz"
  depends_on "zstd"

  resource "jinja2" do
    url "https:files.pythonhosted.orgpackagesaf92b3130cbbf5591acf9ade8708c365f3238046ac7cb8ccba6e81abccb0ccffjinja2-3.1.5.tar.gz"
    sha256 "8fefff8dc3034e27bb80d67c671eb8a9bc424c0ef4c0826edbff304cceff43bb"
  end

  resource "lxml" do
    url "https:files.pythonhosted.orgpackageseff6c15ca8e5646e937c148e147244817672cf920b56ac0bf2cc1512ae674be8lxml-5.3.1.tar.gz"
    sha256 "106b7b5d2977b339f1e97efe2778e2ab20e99994cbb0ec5e55771ed0795920c8"
  end

  resource "markupsafe" do
    url "https:files.pythonhosted.orgpackagesb2975d42485e71dfc078108a86d6de8fa46db44a1a9295e89c5d6d4a06e23a62markupsafe-3.0.2.tar.gz"
    sha256 "ee55d3edf80167e48ea11a923c7386f4669df67d7994554387f84e7d8b0a2bf0"
  end

  def install
    venv = virtualenv_create(buildpath"venv", "python3.13")
    venv.pip_install resources
    ENV.prepend_path "PATH", venv.root"bin"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}systemd"
    ENV["XML_CATALOG_FILES"] = etc"xmlcatalog"

    args = %W[
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      -Dsysvinit-path=#{etc}init.d
      -Dsysvrcnd-path=#{etc}rc.d
      -Drc-local=#{etc}rc.local
      -Dpamconfdir=#{etc}pam.d
      -Dbashcompletiondir=#{bash_completion}
      -Dmode=release
      -Dsshconfdir=no
      -Dsshdconfdir=no
      -Dcreate-log-dirs=false
      -Dhwdb=false
      -Dtests=false
      -Dlz4=enabled
      -Dman=enabled
      -Dacl=disabled
      -Dgcrypt=disabled
      -Dgnutls=disabled
      -Dlibcurl=disabled
      -Dmicrohttpd=disabled
      -Dp11kit=disabled
      -Dpam=disabled
      -Dshellprofiledir=no
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "temporary: tmp", shell_output(bin"systemd-path")
  end
end