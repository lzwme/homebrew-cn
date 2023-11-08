class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://ghproxy.com/https://github.com/orf/gping/archive/refs/tags/gping-v1.15.1.tar.gz"
  sha256 "bd7400c2e20f6bd547de2125c36a370fefab04ee5bf9ad60d38619ecf2114f5b"
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
    sha256 cellar: :any,                 arm64_sonoma:   "bf75c401da8490f86860400b44eab7d70e97b3f385cfd1575d90dfc2eaa58ca7"
    sha256 cellar: :any,                 arm64_ventura:  "123955023e5ddd7880551cc1187b81bb4d9d90658daba874de71f45324e0fc06"
    sha256 cellar: :any,                 arm64_monterey: "cb7cd75727ce6a1c142817a619d9782037e8d76bb24b08e2346c0bf548e408d1"
    sha256 cellar: :any,                 sonoma:         "8e9c8d94e37f631acd169183a98a0fbae8c8c35280273ac484bae94d45f89b25"
    sha256 cellar: :any,                 ventura:        "c1e97c6aad0384752dd502b30f21b933b57050fec7b7b6daa6b165b51b014385"
    sha256 cellar: :any,                 monterey:       "95d1f73b1d0f3e896a638bfa9c21987ac84c18db0bdbeee1ca135ca8746da061"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae0a6583408425897b94a4e7e6666979fb47d09f9a5950596aaf91b5b9e8d319"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"

  on_linux do
    depends_on "iputils"
  end

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
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