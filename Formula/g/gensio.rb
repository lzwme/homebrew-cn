class Gensio < Formula
  desc "Stream IO Library"
  homepage "https:github.comcminyardgensio"
  url "https:github.comcminyardgensioreleasesdownloadv2.8.10gensio-2.8.10.tar.gz"
  sha256 "cc6ab8c27298632ced4dcb451d01b1d160a4e3cb2d1fd2f0277652baebe892d5"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_sequoia: "ed2225280a070cbd368f58265cf123d65d95cd1ee27ea1373e5e9f8c12ea889b"
    sha256 arm64_sonoma:  "b38f7efe7350f78a7a59988e683d343a846c2f95ed1c3125787264a475e3ce0f"
    sha256 arm64_ventura: "d1dae3c5f74df093a3ef209b483b021a1a3ca809eadd8375fe743609fb734dc7"
    sha256 sonoma:        "b94e61b64b6c2302d9dca9257668aceb592be50073ddf8db7aef5c756c02569e"
    sha256 ventura:       "2a9becd3189ac19d72fef238f64aa74296b6bbb3d8ed5ed6288a2a3d5ec34b58"
    sha256 x86_64_linux:  "02f00812b741bc985aa0cf27414fb127a4d381b9a0a1ab7032d11bcb3f82d462"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build

  depends_on "glib"
  depends_on "openssl@3"
  depends_on "python@3.13"

  uses_from_macos "tcl-tk"

  on_macos do
    depends_on "gettext"
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "avahi"
    depends_on "linux-pam"
    depends_on "systemd"
  end

  def python3
    "python3.13"
  end

  def install
    args = %W[
      --disable-silent-rules
      --with-python=#{which(python3)}
      --with-pythoninstall=#{lib}gensio-python
      --sysconfdir=#{etc}
    ]
    args << "--with-tclcflags=-I#{HOMEBREW_PREFIX}includetcl-tk" if OS.linux?

    system ".configure", *args, *std_configure_args
    system "make", "install"
    (prefixLanguage::Python.site_packages(python3)).install_symlink lib.glob("gensio-python*")
  end

  service do
    run [opt_sbin"gtlsshd", "--nodaemon", "--pam-service", "sshd"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}gensiot --version")

    assert_equal "Hello World!", pipe_output("#{bin}gensiot echo", "Hello World!")
  end
end