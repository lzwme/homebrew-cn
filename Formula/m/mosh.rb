class Mosh < Formula
  desc "Remote terminal application"
  homepage "https:mosh.org"
  url "https:github.commobile-shellmoshreleasesdownloadmosh-1.4.0mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 19

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7b92fad6116d55eab1c3a30bc4fe23a1a898748c34bd6fb7e9858aa44057997b"
    sha256 cellar: :any,                 arm64_ventura:  "62f221b0511eb193622d48b62ed79ac3a510af961020642a426ebd174c800d3b"
    sha256 cellar: :any,                 arm64_monterey: "a8a32746f193ac559dae8a6e1485760b194366eb59c7d24a9da8bfd5c6d95247"
    sha256 cellar: :any,                 sonoma:         "f329cfdaa16d35bbdab6bdf4d74fc8adecf8cb7903f74a0edb83e7c3f82c0aba"
    sha256 cellar: :any,                 ventura:        "f7d09f2723953da60dae66ce0cf19b54e9cf226886aacc008cd30975e22f15d9"
    sha256 cellar: :any,                 monterey:       "8f1570c1cee231cd37c80389f7c7f62746f1aadcdfc399fcea1bbbd882e34893"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd1047209e25065ef91511999a8f80ed8fffaec8352a9614480e6cd3d51795fc"
  end

  head do
    url "https:github.commobile-shellmosh.git", branch: "master"

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