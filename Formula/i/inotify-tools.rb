class InotifyTools < Formula
  desc "C library and command-line programs providing a simple interface to inotify"
  homepage "https://github.com/inotify-tools/inotify-tools"
  url "https://ghfast.top/https://github.com/inotify-tools/inotify-tools/archive/refs/tags/4.26.268.tar.gz"
  sha256 "2245a3d86580d93c4bddc140d37b6952a1233148c50df703ca0702f0417e330d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_linux:  "9a6a10c5eceed083b5f851edb11ecc2d44a847179049222d1d853c5c6763763d"
    sha256 cellar: :any, x86_64_linux: "7115abd26e02cd69c6b21804aa307a6be28434409dda9f9fcdfcb1440980f9ba"
  end

  depends_on "rust" => :build
  depends_on :linux

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Stamp the full version like `make dist` does, as the tarball has no git history
    (buildpath/"VERSION").atomic_write "#{version}\n"
    system "make", "install", "prefix=#{prefix}", "mandir=#{man}", "CARGOFLAGS=--locked --offline"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/inotifywait --help", 1)

    touch "test.txt"
    stdin, stdout, stderr, = Open3.popen3("#{bin}/inotifywatch test.txt --timeout 2")
    stdin.close
    assert_match "Establishing watches", stderr.read
    stdout.close
    stderr.close
  end
end