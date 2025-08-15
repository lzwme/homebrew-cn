class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://ghfast.top/https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 29

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "79d2b352fc96b87487c62f21d5026812bdb2787932e48806a0f36dafd4706361"
    sha256 cellar: :any,                 arm64_sonoma:  "ad0579501b6f07f0bb2fed0d64a5de63a1b3de5c5b191d4ae5fd7375a03f47c6"
    sha256 cellar: :any,                 arm64_ventura: "88ec5372e49ab988cd8c9824301876e74507543de244abe4223888a1206e1335"
    sha256 cellar: :any,                 sonoma:        "e5f8aede504269ced65c342970131983c52c355e1c4f239a1a325c22ce87de3c"
    sha256 cellar: :any,                 ventura:       "9e151b601c495d99b7140c41e022225055b8de73d112a19261b5b666c3da9ee2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4fc1beca79337131b78f2516e4b9a3817ee5ce2e087703b0398394bb4f13de8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99df487a2cc425108c827d4e98d8a007d4c156bf4e6a9bbe433fedadcae9572e"
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