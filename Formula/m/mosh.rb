class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://ghfast.top/https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 34

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b079c41c4677549a6ff6e7d94616a5e6f6abf46c3859676441b4f0daf3e94cd8"
    sha256 cellar: :any,                 arm64_sequoia: "af82ce1ff5214494806e856395dd1bf247529d7bae7ff132c00a8a8e00e20e6b"
    sha256 cellar: :any,                 arm64_sonoma:  "4e710ef5e6c7b1202835fe21258dbc843b8350e6ebf19fb4e47fbe2b06fc69f5"
    sha256 cellar: :any,                 sonoma:        "ec777cdc64ba6241420c4d0f498cc209c8c8c74353cf5e93fe444dcc50975a57"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cfb89bcdc908e614de13c3f7d0ab27cf0661b511462dffdf8315911295450027"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "afe1da214baa9919c19b4df44b829fc86c046e9a97d8488b09dea680266e0ce7"
  end

  head do
    url "https://github.com/mobile-shell/mosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkgconf" => :build
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
    # Avoid over-linkage to `abseil`.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

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
    system "make", "install"
  end

  test do
    system bin/"mosh-client", "-c"
  end
end