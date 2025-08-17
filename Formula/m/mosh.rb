class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://ghfast.top/https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 30

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "53e242ef300747f3e5924f5c015124110e3f416e5e8a36e419e15c11ecbbb83e"
    sha256 cellar: :any,                 arm64_sonoma:  "2ff4663c86787ba32f59d5a42c694d2687fae4c735ba3589d982d68ce4a4c8c4"
    sha256 cellar: :any,                 arm64_ventura: "108ff0b7f0d11d4d9fcafd8058a034ca68679540833691bce225b6c558d64462"
    sha256 cellar: :any,                 sonoma:        "2213923323b72d6f7fd7ec2519f1c2d389d557fbeedec9b658ee6d87e646f5e4"
    sha256 cellar: :any,                 ventura:       "5feb362c249154039b0c4015a410545f747ff5dd5987c7072f127dfbee5bf90f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e59aafc3f9fa2e4d9f147d9511b313a91e760d8646b2502f16995cd653682e3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "60386ea64b04304c3733968a209628ddc47cd430b0102e64862a19a39258b547"
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