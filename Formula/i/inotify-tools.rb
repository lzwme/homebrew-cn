class InotifyTools < Formula
  desc "C library and command-line programs providing a simple interface to inotify"
  homepage "https://github.com/inotify-tools/inotify-tools"
  url "https://ghfast.top/https://github.com/inotify-tools/inotify-tools/archive/refs/tags/4.26.262.tar.gz"
  sha256 "989895241148580c820872ecd4f2b06f3dd8c5d72f61c4852dbf936beb2b067f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_linux:  "ee1338b81dbe59daa6a3be5092c045ab6f46cd6acd010060feb6ec4b06eaf0a8"
    sha256 cellar: :any, x86_64_linux: "b4b56eb04e9f5a0a6d86679c0ef564b34e037a3eb4bb00c3e02dd9e63b8afa04"
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