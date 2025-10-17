class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://ghfast.top/https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 32

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3ff96d03ddf6b2bc88c24356ea21f47f11c69eee98edbbc45c2bf99a7144b539"
    sha256 cellar: :any,                 arm64_sequoia: "fc5235fc2e1e942bc5dc5af210223ad5c789a369222544b96684a004a8f0bae5"
    sha256 cellar: :any,                 arm64_sonoma:  "8c914e315a836f1ace959ab5b6a8cba742ccff6e2e284b354892f4236adcdd6d"
    sha256 cellar: :any,                 sonoma:        "0286268892f25ec0b208740cfba7d878ac5ef1f4a7ca7264921f6b91c5c96c7e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52bdecdf496c604b86964f29c1a64e2928e2fc31212830424f845d88e75c58bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11a0eb08ac813d18dd123df4393aed50e713e9d88f29da46d636f5e9e6b97a3c"
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