class Mosh < Formula
  desc "Remote terminal application"
  homepage "https:mosh.org"
  url "https:github.commobile-shellmoshreleasesdownloadmosh-1.4.0mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 25

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a0e4bff32524b9472e390c4890b783fbd0eb5d5ef9fbe84c7a4be5650f0f78ff"
    sha256 cellar: :any,                 arm64_sonoma:  "b79d4d63237042f3ea49e0d9f36ba2077fe1d3d408240bcdb1c168735487f738"
    sha256 cellar: :any,                 arm64_ventura: "a55ad85918f595d3a45ae5d4b2074b342206fcbe62ef5708e028b825c42e9f63"
    sha256 cellar: :any,                 sonoma:        "2c932ae3a5559053cb32873cb96d5905aefe8586e6b0ecfb3718691302c42d20"
    sha256 cellar: :any,                 ventura:       "13b969a127103412a4f5f8f652dab19eaec40a175f91d77fdc40acde51298977"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "414913f607d953c873ca9cb8eb9ea76dc077522946b78621fd819d397aea506e"
  end

  head do
    url "https:github.commobile-shellmosh.git", branch: "master"

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
    # https:github.comprotocolbuffersprotobufissues9947
    ENV.append_to_cflags "-DNDEBUG"
    # Avoid over-linkage to `abseil`.
    ENV.append "LDFLAGS", "-Wl,-dead_strip_dylibs" if OS.mac?

    # teach mosh to locate mosh-client without referring
    # PATH to support launching outside shell e.g. via launcher
    inreplace "scriptsmosh.pl", "'mosh-client", "'#{bin}mosh-client"

    if build.head?
      # Prevent mosh from reporting `-dirty` in the version string.
      inreplace "Makefile.am", "--dirty", "--dirty=-Homebrew"
      system ".autogen.sh"
    elsif version <= "1.4.0" # remove `elsif` block and `else` at version bump.
      # Keep C++ standard in sync with abseil.rb.
      # Use `gnu++17` since Mosh allows use of GNU extensions (-std=gnu++11).
      ENV.append "CXXFLAGS", "-std=gnu++17"
    else # Remove `else` block at version bump.
      odie "Install method needs updating!"
    end

    # `configure` does not recognise `--disable-debug` in `std_configure_args`.
    system ".configure", "--prefix=#{prefix}", "--enable-completion", "--disable-silent-rules"
    # Mosh provides remote shell access, so let's run the tests to avoid shipping an insecure build.
    system "make", "check" if OS.mac? # Fails on Linux.
    system "make", "install"
  end

  test do
    system bin"mosh-client", "-c"
  end
end