class Mosh < Formula
  desc "Remote terminal application"
  homepage "https:mosh.org"
  url "https:github.commobile-shellmoshreleasesdownloadmosh-1.4.0mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 17

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d6a5570b0a037edd8d912818c9d5f44616e065321bc9ddbe159f497551ed6413"
    sha256 cellar: :any,                 arm64_ventura:  "e48f25601ff46ae4bf10823364371521eaf2cac92cc18ada441e9370e99df4c8"
    sha256 cellar: :any,                 arm64_monterey: "4f84a9f1610ab1e8918ad6ab9c8594e923b4a26831bccbff68c3c43d5c967635"
    sha256 cellar: :any,                 sonoma:         "301857b1c8060da006747702c24ae98e72cf97f4c18f016c185a76351af57917"
    sha256 cellar: :any,                 ventura:        "35b115d649d8b8d7c4eef50880045954ab827e1c2c7cda4ffe3d3c3dcc110114"
    sha256 cellar: :any,                 monterey:       "360bff02de052e6eca699431951b74f2a6756fd7ceea27f76a8d64db20708143"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "204acbe12c0adda2c4663b2f11f37dc0ab32a53a362d5539422786d451122254"
  end

  head do
    url "https:github.commobile-shellmosh.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "abseil"
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