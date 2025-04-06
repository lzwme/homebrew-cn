class Gensio < Formula
  desc "Stream IO Library"
  homepage "https:github.comcminyardgensio"
  url "https:github.comcminyardgensioreleasesdownloadv2.8.13gensio-2.8.13.tar.gz"
  sha256 "dc6dfce20782128c75c60ac3a1791d37691f8e0de5fa58817e984dcd9ecf597f"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_sequoia: "0f3ae70309e932c4327339f4a454dbe172eae31f87ce9fb14f1f3d8be748916d"
    sha256 arm64_sonoma:  "4ea8d15dfdd2b68a7c0a64aaf957c2ae863f7141db60f53c942d2d61fc6a0d2b"
    sha256 arm64_ventura: "a3c91cd9c23f204ab2cda3dc5813888040f187fcd0eb897daa7e5a47fa05371d"
    sha256 sonoma:        "b8a236d366db64e6b2856dac86881aeed86de7ee448300c644dba8e02cc02fe4"
    sha256 ventura:       "22940f3bcd0f17fa2452f87ff1a44c25eed10fa3b03f5c1a749053decba9f6c8"
    sha256 x86_64_linux:  "31b08dc6d5c1a8bc13939135daded49a46c4fb9ca2ad68ec5e977da4b31f0788"
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