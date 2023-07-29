class Systemd < Formula
  desc "System and service manager"
  homepage "https://wiki.freedesktop.org/www/Software/systemd/"
  url "https://ghproxy.com/https://github.com/systemd/systemd-stable/archive/refs/tags/v254.tar.gz"
  sha256 "18db69c8fc33afebf95a40cfa3769df5f0e4a07bccdebd33b2fd81c8b75e7a02"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]
  head "https://github.com/systemd/systemd.git", branch: "main"

  bottle do
    sha256 x86_64_linux: "ec7fe5637b9ba5c52de93525c3c05796c7b96b07b3f08fd0831148f32958fa28"
  end

  depends_on "coreutils" => :build
  depends_on "docbook-xsl" => :build
  depends_on "gettext" => :build
  depends_on "gperf" => :build
  depends_on "intltool" => :build
  depends_on "jinja2-cli" => :build
  depends_on "libgpg-error" => :build
  depends_on "libtool" => :build
  depends_on "libxslt" => :build
  depends_on "m4" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "rsync" => :build
  depends_on "expat"
  depends_on "glib"
  depends_on "libcap"
  depends_on :linux
  depends_on "lz4"
  depends_on "openssl@3"
  depends_on "util-linux" # for libmount
  depends_on "xz"
  depends_on "zstd"

  uses_from_macos "libxcrypt"

  def install
    ENV["PYTHONPATH"] = Formula["jinja2-cli"].opt_libexec/Language::Python.site_packages("python3.11")
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/systemd"

    args = %W[
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      -Drootprefix=#{prefix}
      -Dsysvinit-path=#{etc}/init.d
      -Dsysvrcnd-path=#{etc}/rc.d
      -Dpamconfdir=#{etc}/pam.d
      -Dbashcompletiondir=#{bash_completion}
      -Dcreate-log-dirs=false
      -Dhwdb=false
      -Dlz4=true
      -Dgcrypt=false
      -Dp11kit=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match "temporary: /tmp", shell_output("#{bin}/systemd-path")
  end
end