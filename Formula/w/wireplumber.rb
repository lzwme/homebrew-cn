class Wireplumber < Formula
  desc "Session / policy manager implementation for PipeWire"
  homepage "https://pipewire.pages.freedesktop.org/wireplumber/"
  url "https://gitlab.freedesktop.org/pipewire/wireplumber/-/archive/0.5.18/wireplumber-0.5.18.tar.bz2"
  sha256 "0c2ea30a7b3bb4ecad456bb27e2c283defda59bb53d97df6917a495f12887e33"
  license "MIT"

  bottle do
    sha256 arm64_linux:  "71ec3ba312fca24868b9ae53663e87ceea11b835abcd6dfc368142a49206b3f8"
    sha256 x86_64_linux: "e48c73c52a4f54cc2a7b495c1ca9103d863c56741489a0d5bde09de5a4fe3b97"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "dbus" => :test

  depends_on "glib"
  depends_on :linux
  depends_on "lua"
  depends_on "pipewire"
  depends_on "systemd"

  def install
    args = %W[
      -Ddoc=disabled
      -Dsysconfdir=#{etc}
      -Dsystem-lua=true
      -Dtests=false
    ]
    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    ENV["XDG_DATA_DIRS"] = testpath # avoid loading system dbus services
    ENV["XDG_RUNTIME_DIR"] = testpath
    ENV["DBUS_SESSION_BUS_ADDRESS"] = address = "unix:path=#{testpath}/bus"
    dbus_pid = spawn(formula_opt_bin("dbus")/"dbus-daemon", "--session", "--nofork", "--address=#{address}")
    sleep 5
    pipewire_pid = spawn(formula_opt_bin("pipewire")/"pipewire")
    sleep 5
    assert_match "PipeWire 'pipewire-0'", shell_output("#{bin}/wpctl status")
  ensure
    [pipewire_pid, dbus_pid].each do |pid|
      next unless pid

      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end