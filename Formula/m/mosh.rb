class Mosh < Formula
  desc "Remote terminal application"
  homepage "https:mosh.org"
  url "https:github.commobile-shellmoshreleasesdownloadmosh-1.4.0mosh-1.4.0.tar.gz"
  sha256 "872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd"
  license "GPL-3.0-or-later"
  revision 23

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "25be0f7effe4bfcdfc04e0d9f3dcb55b7ca7b628446309280f72bd05b0d1b69c"
    sha256 cellar: :any,                 arm64_sonoma:  "7601add7a4c8c249ff5332773cd12d27edd2b25ce2d384858b64df8300055073"
    sha256 cellar: :any,                 arm64_ventura: "d410b902c5d169273643669461b26b96bfc17398c8cbc2637efb2ab355656ca0"
    sha256 cellar: :any,                 sonoma:        "6fd3a2bc50689a0e023f52264165c0cdf42090d556324039e17a07791a2f0849"
    sha256 cellar: :any,                 ventura:       "d4c526e38fd611c32af724a3c1d8f28d39c0b677045cf6a14f0c508cccaafe2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7a77257eded71c0b6b57db07f936dd1679788466112874d78e00ecdfca5483bf"
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