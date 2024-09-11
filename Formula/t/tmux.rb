class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https:tmux.github.io"
  license "ISC"
  revision 1

  stable do
    url "https:github.comtmuxtmuxreleasesdownload3.4tmux-3.4.tar.gz"
    sha256 "551ab8dea0bf505c0ad6b7bb35ef567cdde0ccb84357df142c254f35a23e19aa"

    # Upstream fix for macOS 15 headers, remove in next version
    patch do
      url "https:github.comtmuxtmuxcommit775789fbd5c4f3aa93061480cd64e61daf7fb689.patch?full_index=1"
      sha256 "c1b61a1244f758480578888d3f89cac470271c376ea0879996b81e10b397cad0"
    end
  end

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+[a-z]?)i)
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia:  "79da3c04d1147057cbe3ecf344bae3126b61ff18f4d0cf7d5470b01b6b30948c"
    sha256 cellar: :any,                 arm64_sonoma:   "6b407b3351b79919c482d46134c9e83552f3e848f1c482a7deec65c36cf16d37"
    sha256 cellar: :any,                 arm64_ventura:  "a5a47403c75e2d14370ff07641294bd361eceb8ca2dc65925e5eb7e41453d727"
    sha256 cellar: :any,                 arm64_monterey: "2233d5fd7333fdf3da6dbe48157735c276f27cd7dd274d0e704985c9105e77b0"
    sha256 cellar: :any,                 sonoma:         "2a085e0752332536a198aac71cd6b24a10f6feb0bf1825f90551cd6ef5e8c890"
    sha256 cellar: :any,                 ventura:        "0648a51759f9c37ab98ff9b2558d30aa7ec07a7c7979a4107263e080382d0c0c"
    sha256 cellar: :any,                 monterey:       "ec64b5ad6daf6bf6cb99cd2580fdf6cfee9830fcedc4971fa9be033710d1774a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05e737d00a0f331d48468c8f7f96f70e8879c5e9ffb9fcae9fb1fdae4f71bcd4"
  end

  head do
    url "https:github.comtmuxtmux.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "ncurses"

  uses_from_macos "bison" => :build # for yacc

  # Old versions of macOS libc disagree with utf8proc character widths.
  # https:github.comtmuxtmuxissues2223
  on_system :linux, macos: :sierra_or_newer do
    depends_on "utf8proc"
  end

  resource "completion" do
    url "https:raw.githubusercontent.comimomalievtmux-bash-completion8da7f797245970659b259b85e5409f197b8afdddcompletionstmux"
    sha256 "4e2179053376f4194b342249d75c243c1573c82c185bfbea008be1739048e709"
  end

  def install
    system "sh", "autogen.sh" if build.head?

    args = %W[
      --enable-sixel
      --sysconfdir=#{etc}
    ]

    if OS.mac?
      # tmux finds the `tmux-256color` terminfo provided by our ncurses
      # and uses that as the default `TERM`, but this causes issues for
      # tools that link with the very old ncurses provided by macOS.
      # https:github.comHomebrewhomebrew-coreissues102748
      args << "--with-TERM=screen-256color" if MacOS.version < :sonoma
      args << "--enable-utf8proc" if MacOS.version >= :high_sierra
    else
      args << "--enable-utf8proc"
    end

    ENV.append "LDFLAGS", "-lresolv"
    system ".configure", *args, *std_configure_args

    system "make", "install"

    pkgshare.install "example_tmux.conf"
    bash_completion.install resource("completion")
  end

  def caveats
    <<~EOS
      Example configuration has been installed to:
        #{opt_pkgshare}
    EOS
  end

  test do
    system bin"tmux", "-V"

    require "pty"

    socket = testpathtap.user
    PTY.spawn bin"tmux", "-S", socket, "-f", "devnull"
    sleep 10

    assert_predicate socket, :exist?
    assert_predicate socket, :socket?
    assert_equal "no server running on #{socket}", shell_output("#{bin}tmux -S#{socket} list-sessions 2>&1", 1).chomp
  end
end