class Tmux < Formula
  desc "Terminal multiplexer"
  homepage "https:tmux.github.io"
  url "https:github.comtmuxtmuxreleasesdownload3.5tmux-3.5.tar.gz"
  sha256 "2fe01942e7e7d93f524a22f2c883822c06bc258a4d61dba4b407353d7081950f"
  license "ISC"

  livecheck do
    url :stable
    regex(v?(\d+(?:\.\d+)+[a-z]?)i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "981ba63b0f09a3f42968805b4a7ce9b6b3198152646ba201b6d8dbdf7f736929"
    sha256 cellar: :any,                 arm64_sonoma:  "a2532c0bb5a7aa570c8454f6cd4f4df08fc6606345a8e9fc7e56f7b7b61a38c5"
    sha256 cellar: :any,                 arm64_ventura: "d81b0f00925d5b6e2568875512bcf8666d19d196d619313946cb715e5fda4839"
    sha256 cellar: :any,                 sonoma:        "bafcf00422fcde3845487181f872688946966e5caabec6ea9ae0eac9aee40e3c"
    sha256 cellar: :any,                 ventura:       "5863900439737e5eb23779055a2aedab1c3513bb48a36aadc629c3fb66a98d6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e57b135585e80c982946d364053337171184bdb1cd75eba1cb3efc8768358ee"
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