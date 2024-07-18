class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https:github.comorfgping"
  url "https:github.comorfgpingarchiverefstagsgping-v1.16.1.tar.gz"
  sha256 "557dad6e54b5dd23f88224ea7914776b7636672f237d9cbbea59972235ca89a8"
  license "MIT"
  revision 1
  head "https:github.comorfgping.git", branch: "master"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https:github.comHomebrewhomebrew-corepull66366#discussion_r537339032
  livecheck do
    url :stable
    regex(^gping[._-]v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c620c9087b5cf4aa3848ca4fc068209164cfde8f0dd54284794118a3232622fd"
    sha256 cellar: :any,                 arm64_ventura:  "d83c2735767e7ec8f483315df1e5865ea615c45d6cd8989db161f75cdb56d1b8"
    sha256 cellar: :any,                 arm64_monterey: "131c1f7da640bbc4a2c7fdfd315b35f0c94238684d7f58cab8d742b4400063ed"
    sha256 cellar: :any,                 sonoma:         "dbb3e46597fde402108c54ebda1887fa890bbec1395e5a81c944d38cc7cafda4"
    sha256 cellar: :any,                 ventura:        "ccfb2382fb3d1c733421d9b7405c273d89ac1149de03ec09236dca977402c573"
    sha256 cellar: :any,                 monterey:       "6741f1ec2ef9a930ea5ae07694f35aa38dc7412f15ef808fda1104b8bc5545cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccf8e3a8152e86c8204a4eb65300e686f33e820cb463b011318e3831c77a5733"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.7"

  on_linux do
    depends_on "iputils"
  end

  conflicts_with "inetutils", because: "both install `gping` binaries"

  def install
    ENV["LIBGIT2_NO_VENDOR"] = "1"
    system "cargo", "install", *std_cargo_args(path: "gping")
  end

  test do
    require "pty"
    require "ioconsole"

    r, w, = PTY.spawn("#{bin}gping google.com")
    r.winsize = [80, 130]
    sleep 10
    w.write "q"

    begin
      screenlog = r.read
      # remove ANSI colors
      screenlog.encode!("UTF-8", "binary",
        invalid: :replace,
        undef:   :replace,
        replace: "")
      screenlog.gsub!(\e\[([;\d]+)?m, "")

      assert_match "google.com (", screenlog
    rescue Errno::EIO
      # GNULinux raises EIO when read is done on closed pty
    end

    return unless OS.mac?

    linkage_with_libgit2 = (bin"gping").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.7"].opt_libshared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end