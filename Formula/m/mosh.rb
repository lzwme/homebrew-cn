class Mosh < Formula
  desc "Remote terminal application"
  homepage "https:mosh.org"
  url "https:github.commobile-shellmoshreleasesdownloadmosh-1.4.0mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 10

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "11889adf1ed7b43e2f31e1109f81f3564f983d587f9970fd5725ba890a5ad9db"
    sha256 cellar: :any,                 arm64_ventura:  "b9428a84a290385a426e7c41e61987c6fea314896567075614c424d25da67c05"
    sha256 cellar: :any,                 arm64_monterey: "7e6eb9586a35a7361d1011716605b2533b13b5f2c22d6afdcd6fdfa593218b63"
    sha256 cellar: :any,                 sonoma:         "9264262b960c50fe1d260615c33af45a9dd4d012b40987a327d1abb8223cb309"
    sha256 cellar: :any,                 ventura:        "9312db1b1b7911e57cad50f8b7579bc109b1e50309c7d29edd0fa54145ad1b8e"
    sha256 cellar: :any,                 monterey:       "3a8c080a86a6501edf4bf82a0a4dfdcb28ab2ddff45ff810f4ada11c113d8a03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c5b8d7f1f605030bbe7628fc63505371678c61f0441f8fb8d807efd855f08a"
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