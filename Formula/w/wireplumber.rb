class Wireplumber < Formula
  desc "Session / policy manager implementation for PipeWire"
  homepage "https://pipewire.pages.freedesktop.org/wireplumber/"
  url "https://gitlab.freedesktop.org/pipewire/wireplumber/-/archive/0.5.16/wireplumber-0.5.16.tar.bz2"
  sha256 "2c99030a3aa6e5895e8ca0d985b4a9de12255aa85a21f2edd49f94a83b59af81"
  license "MIT"

  bottle do
    sha256 arm64_linux:  "e68d299ce09bf7eff448d40ce918896e27aafba2cd7b3b12754283ca384fab0a"
    sha256 x86_64_linux: "84a1a02b9d070c837a36eb6f7f045c41115080143f14fb60fdeccac1160a816a"
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
    dbus_pid = spawn(Formula["dbus"].bin/"dbus-daemon", "--session", "--nofork", "--address=#{address}")
    sleep 5
    pipewire_pid = spawn(Formula["pipewire"].bin/"pipewire")
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