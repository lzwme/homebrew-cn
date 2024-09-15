class Mosh < Formula
  desc "Remote terminal application"
  homepage "https:mosh.org"
  url "https:github.commobile-shellmoshreleasesdownloadmosh-1.4.0mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 20

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "35e4adfb1723820be0cd4cd4b7e2347630b81a7c80459fc37d6221055be3e928"
    sha256 cellar: :any,                 arm64_sonoma:  "84d2d9ef55e76279a01e8c4e89a6523cadc3d577675b6be6a80b50500fe30856"
    sha256 cellar: :any,                 arm64_ventura: "89692d69c41b4ed2be29981b2737e5e3ef5538085e88a31162ee03f9a4bd4a3e"
    sha256 cellar: :any,                 sonoma:        "3291795a4326cdb40291c6888f7da29026c425d135c3f971ecef8de5ee9d822d"
    sha256 cellar: :any,                 ventura:       "b191d84dd88969c4ede3f1c9d2531e7e91f9793fd99571932016bbf3f6df4261"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c71b3dd9592f1035aac432c88a99f2f342f244294ce565c31b3876fe46698b4"
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