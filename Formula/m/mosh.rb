class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://ghproxy.com/https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c52e7bd55c91a623e7845478c3b00e22f9a5a0acf64dd2fc1423882253ad323"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99e5a62a3d5daca45b137f6c00ba40416e462ef0ef191f28e9c92f52089830a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e92f1e47d3901316b8d3bb44b256bbb1e53f1e11820963d97736996bc16f9f2d"
    sha256 cellar: :any_skip_relocation, ventura:        "b10c2b2340597f6c761b36050a1760a62b34db36a6f0d76bf116d789c749cef1"
    sha256 cellar: :any_skip_relocation, monterey:       "b9652751caabfc7fa813bbec2824a20667cfa7833f1871a80790b29a2c9bc12f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2864197dbe87b91fb90e342023a3ba943867770ac53f9e3dd13ba2c8899957cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f73161e554caa84dd4a340271cd3122cb4852c52b2c48ab5a87003d98044d75"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "protobuf"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_macos do
    depends_on "tmux" => :build # for `make check`
  end

  on_linux do
    depends_on "openssl@3" # Uses CommonCrypto on macOS
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scripts/mosh.pl", "'mosh-client", "'#{bin}/mosh-client"

    if build.head?
      # Prevent mosh from reporting `-dirty` in the version string.
      inreplace "Makefile.am", "--dirty", "--dirty=-Homebrew"
      system "./autogen.sh"
    elsif version <= "1.4.0" # remove `elsif` block and `else` at version bump.
      # Keep C++ standard in sync with abseil.rb.
      # Use `gnu++17` since Mosh allows use of GNU extensions (-std=gnu++11).
      ENV.append "CXXFLAGS", "-std=gnu++17"
    else # Remove `else` block at version bump.
      odie "Install method needs updating!"
    end

    # `configure` does not recognise `--disable-debug` in `std_configure_args`.
    system "./configure", "--prefix=#{prefix}", "--enable-completion", "--disable-silent-rules"
    # Mosh provides remote shell access, so let's run the tests to avoid shipping an insecure build.
    system "make", "check" if OS.mac? # Fails on Linux.
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end