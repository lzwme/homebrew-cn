class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://ghproxy.com/https://github.com/orf/gping/archive/gping-v1.13.1.tar.gz"
  sha256 "5bdf36ffe6a8cd7979fdd54dc48c76ad96fc65af11929e17b3b686992d32e541"
  license "MIT"
  head "https://github.com/orf/gping.git", branch: "master"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https://github.com/Homebrew/homebrew-core/pull/66366#discussion_r537339032
  livecheck do
    url :stable
    regex(/^gping[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3fb7e618a967b02b3f9b0e3c3616e406ebf1c8f8877bdd91b35b05268fb4ec8e"
    sha256 cellar: :any,                 arm64_monterey: "8f16188502058600b54d34dc08d4fdbee1622785c9775ddfcdd2f856d0332f85"
    sha256 cellar: :any,                 arm64_big_sur:  "b0a9d6fe07c3c2473b9f2cbefc8eb9cb7c250aac86468e037f4821ab94101f04"
    sha256 cellar: :any,                 ventura:        "33218fcff023df205023a43beec4f3cab6d33a0a5c57ade62c6848586d013a23"
    sha256 cellar: :any,                 monterey:       "945739c62259fc26eac2ac165c21b5414a63bcf3faf9080cf2770fcd7c837cc3"
    sha256 cellar: :any,                 big_sur:        "1105136b774d96c1ada2475ffd1e14dceabc4304fd149d4107af3a3c0c82c53b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "350754d2a44ef5f1a5915b97da7db19c40b20729925af82d45f75d0c453be136"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_macos do
    depends_on "libgit2"
  end

  on_linux do
    depends_on "iputils"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "gping")
  end

  test do
    require "pty"
    require "io/console"

    r, w, = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 1
    w.write "q"

    begin
      screenlog = r.read
      # remove ANSI colors
      screenlog.encode!("UTF-8", "binary",
        invalid: :replace,
        undef:   :replace,
        replace: "")
      screenlog.gsub!(/\e\[([;\d]+)?m/, "")

      assert_match "google.com (", screenlog
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    return unless OS.mac?

    linkage_with_libgit2 = (bin/"gping").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end