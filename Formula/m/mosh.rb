class Mosh < Formula
  desc "Remote terminal application"
  homepage "https://mosh.org"
  url "https://ghproxy.com/https://github.com/mobile-shell/mosh/releases/download/mosh-1.4.0/mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8978c29279fc1cd41da7a99fc822abca729f84bd1cfbe7e771850cbbd9526196"
    sha256 cellar: :any,                 arm64_ventura:  "3cde3013718322848ea14101f029fd582b624eae86887e3854b1da14e0d4cb9d"
    sha256 cellar: :any,                 arm64_monterey: "30a7d1bb1096e0b1a3d5253dfa71801bbb606c6c5497bbd472efb834a59ffcde"
    sha256 cellar: :any,                 sonoma:         "1439d63cfb07be56b3a5ce133273ad51b5ba6d30842270f02fe1f1a7806e4644"
    sha256 cellar: :any,                 ventura:        "8b3244f63c8be0d6a033bc360495e1125e505d737f60a94c693a0581eb8224eb"
    sha256 cellar: :any,                 monterey:       "c182c981b85772f3de20017c2abc15abbff1526327c25bd32b78d0d68a406fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56309e6ca9014cb174e06b0623f45b9e29a60f8a925ae0527428494ed3c3131a"
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