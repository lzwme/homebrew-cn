class Gensio < Formula
  desc "Stream I/O Library"
  homepage "https://github.com/cminyard/gensio"
  url "https://ghfast.top/https://github.com/cminyard/gensio/releases/download/v3.0.0/gensio-3.0.0.tar.gz"
  sha256 "67e621b47aa7cd7cdf148398cf99f8d8b606f2598e731207debd649dcf9ef5f0"
  license all_of: ["LGPL-2.1-only", "GPL-2.0-only", "Apache-2.0"]

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "3b4ff35427dd32f4bb44491e483843cba1db330b5e09cc37f5bf103164b920fe"
    sha256 arm64_sequoia: "10b45c554267200223222527b996cb7407fc53dce0a46a7e4cd3f1674d3a8269"
    sha256 arm64_sonoma:  "076afbb6889cc4487c52b1be26022ba19ccb335e57aac3661333be7c8a336826"
    sha256 sonoma:        "0cc0df5a11267b073daa009064988927886f35e86af3fc493955896f5e642a17"
    sha256 arm64_linux:   "49b7e558af7bfaa2e4b3427aa4401266afcd3562b324a7889b23645607fbc5c4"
    sha256 x86_64_linux:  "8b811a7e4b249d84319d1dc4f3e4ca362ec8adc83eb461f3ff343784ba6ec947"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build
  depends_on "swig" => :build

  depends_on "glib"
  depends_on "openssl@3"
  depends_on "python@3.14"
  depends_on "tcl-tk"

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
    "python3.14"
  end

  def install
    ENV["CGO_ENABLED"] = "1" if OS.linux? && Hardware::CPU.arm?

    tcltk = Formula["tcl-tk"]
    args = %W[
      --disable-silent-rules
      --with-python=#{which(python3)}
      --with-pythoninstall=#{lib}/gensio-python
      --with-tclcflags=-I#{tcltk.opt_include}/tcl-tk
      --with-tcllibs=-ltcl#{tcltk.version.major_minor}
      --sysconfdir=#{etc}
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"
    (prefix/Language::Python.site_packages(python3)).install_symlink lib.glob("gensio-python/*")
  end

  service do
    run [opt_sbin/"gtlsshd", "--nodaemon", "--pam-service", "sshd"]
    keep_alive true
    require_root true
    working_dir HOMEBREW_PREFIX
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gensiot --version")

    assert_equal "Hello World!", pipe_output("#{bin}/gensiot echo", "Hello World!")
  end
end