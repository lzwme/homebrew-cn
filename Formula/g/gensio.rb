class Gensio < Formula
  desc "Stream IO Library"
  homepage "https:github.comcminyardgensio"
  url "https:github.comcminyardgensioreleasesdownloadv2.8.12gensio-2.8.12.tar.gz"
  sha256 "f7dc447c1eed51a9349ab120665eb5db26ed83150cd991764b0ca89b3bac769f"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    sha256 arm64_sequoia: "431129333a6bed27527e514db4eb6b431909024515f675f1e1960ae9a674cb4f"
    sha256 arm64_sonoma:  "205f192516e3e660e6840ca2d70a9c070a5fb3700d70624ef46b259af61b0df1"
    sha256 arm64_ventura: "1502c3893982c52a0dd3ab8bab343d0294f4fe6b64e93b395a4be76c34c3dac2"
    sha256 sonoma:        "f649556473b03a3205ee87ed4c2ae7750985eb9d8065670a497aa8dba92ae754"
    sha256 ventura:       "f091d1eb298b10a0ca987159054e00d707e06c265a5861ebd21629c935374ea1"
    sha256 x86_64_linux:  "5a0dc26dfde6304e02377cd1ae0361b011707f5662abb057edfceadcb4a049da"
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