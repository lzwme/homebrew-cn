class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://ghproxy.com/https://github.com/orf/gping/archive/refs/tags/gping-v1.16.0.tar.gz"
  sha256 "2e9642dbcb2ba69c4cfe0a1cd9218fbffca741c776c7dc864c0d6dc5550330ab"
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
    sha256 cellar: :any,                 arm64_sonoma:   "9dbd8442a51c5cead4e5860ef752808404d79e113efbbe428baa2bb26c1d9072"
    sha256 cellar: :any,                 arm64_ventura:  "662b2b5a3eeabe9e5f03a60675556f03f35c1f6d6242b63fca37744c789316a1"
    sha256 cellar: :any,                 arm64_monterey: "e895a077fd09ae61270fca27d264acbb8000dbc6c20abbf4b4c2e09d06f8ec2d"
    sha256 cellar: :any,                 sonoma:         "ce90adc71b5bac59f65668472846841b69fafcb445f13c05df0d17d97b66e595"
    sha256 cellar: :any,                 ventura:        "b3f63d77d22a5d4c4c5a38b12acb5b4f2766cea08f1756e1a2cd2d6aa5b76796"
    sha256 cellar: :any,                 monterey:       "bc2a79d096c8194968d37fac8d64acb448eae54a1d86ea7350b16d3da7d98721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a09a6fe89f84883605331b3e073392c84fbf7a3366408f9584a42f27a6ebf085"
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