class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://ghfast.top/https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.39.tar.gz"
  sha256 "24b3423353ce7063cb36d0329141605e4f39ffb28e1be6745fddc16af0755de7"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "96eeba7970347016e0687e345d9eaf64603208b2bfaf5e314c30284e88f90722"
    sha256 cellar: :any, arm64_tahoe:       "d8cffbc15932e6a4fb431aafb391ab9aedb93ab9fb466dc20a13c33034795777"
    sha256 cellar: :any, arm64_sequoia:     "68202c2152588581b828bab53dad7252524cb10469c968127fd2c200e6abba3b"
    sha256 cellar: :any, arm64_linux:       "ba689005e8e207e5527c256928e096d5ab02a58f22e59421876c0b16c6b3330d"
    sha256 cellar: :any, x86_64_linux:      "5726fd2d4306e6b2c1dcd98574996d8a919450db89613f6341c5dedfea31e7db"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "libadwaita"
  depends_on "libcanberra"
  depends_on "libspelling"
  depends_on "pango"
  depends_on "pcre2"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    system "go", "build", *std_go_args
  end

  test do
    # dissent is a GUI application
    cmd = "#{bin}/dissent --help"

    pid = nil
    if OS.linux?
      IO.pipe do |read_io, write_io|
        pid = spawn(formula_opt_bin("xorg-server")/"Xvfb", "-displayfd", write_io.fileno.to_s, write_io => write_io)
        write_io.close
        ENV["DISPLAY"] = ":#{read_io.read.strip}"
      end
    end

    assert_match "Show all help options", shell_output(cmd)
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end