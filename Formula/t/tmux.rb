class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https://tmux.github.io/"
  url "https://ghfast.top/https://github.com/tmux/tmux/releases/download/3.6b/tmux-3.6b.tar.gz"
  sha256 "5ce92c0ab4ac6a465cf6f8e988ca0aefd3b5ba1e4f6fa5bc4c92aa8546641021"
  license "ISC"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/v?(\d+(?:\.\d+)+[a-z]?)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8157bc6158cd422720e63e229b69d0ae802154c499ed427abc7ba9a428928341"
    sha256 cellar: :any,                 arm64_sequoia: "7b804ba25ee8813b7c68f8a946ddcda53377fa45af43e5f6135ea3fe712caec2"
    sha256 cellar: :any,                 arm64_sonoma:  "373acbde2c9d6fb14765e26b3567a1099f293ba36bf9c93419e7bdd4ea76bbec"
    sha256 cellar: :any,                 sonoma:        "5523fd40955a7d54f4d32ff96a603443b592c44b84497a5af030ee07bd9ffaf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea06a4a2159da77c95c73bf2c76f68e5215c080ef4a283a267f179aa679d6299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b5620e1fad221665fdae46538bb6a317fab242d1e7188e8ef8f58e7b8eccfdf"
  end

  head do
    url "https://github.com/tmux/tmux.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"
  depends_on "ncurses"
  depends_on "utf8proc"

  uses_from_macos "bison" => :build # for yacc

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --enable-sixel
      --sysconfdir=#{etc}
      --enable-utf8proc
    ]

    # tmux finds the `tmux-256color` terminfo provided by our ncurses
    # and uses that as the default `TERM`, but this causes issues for
    # tools that link with the very old ncurses provided by macOS.
    # https://github.com/Homebrew/homebrew-core/issues/102748
    args << "--with-TERM=screen-256color" if OS.mac? && MacOS.version < :sonoma

    system "./configure", *args, *std_configure_args
    system "make", "install"

    pkgshare.install "example_tmux.conf"
  end

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    system bin/"tmux", "-V"

    require "pty"

    socket = testpath/tap.user
    PTY.spawn bin/"tmux", "-S", socket, "-f", File::NULL
    sleep 10

    assert_path_exists socket
    assert_predicate socket, :socket?
    assert_equal "no server running on #{socket}", shell_output("#{bin}/tmux -S#{socket} list-sessions 2>&1", 1).chomp
  end
end