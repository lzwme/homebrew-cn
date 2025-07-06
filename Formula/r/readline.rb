class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.3.tar.gz"
  sha256 "fe5383204467828cd495ee8d1d3c037a7eba1389c22bc6a041f627976f9061cc"
  license "GPL-3.0-or-later"

  # Add new patches using this format:
  #
  # patch_checksum_pairs = %w[
  #   001 <checksum for 8.3.1>
  #   002 <checksum for 8.3.2>
  #   ...
  # ]

  patch_checksum_pairs = %w[]

  patch_checksum_pairs.each_slice(2) do |p, checksum|
    patch :p0 do
      url "https://ftp.gnu.org/gnu/readline/readline-8.3-patches/readline83-#{p}"
      mirror "https://ftpmirror.gnu.org/readline/readline-8.3-patches/readline83-#{p}"
      sha256 checksum
    end
  end

  # We're not using `url :stable` here because we need `url` to be a string
  # when we use it in the `strategy` block.
  livecheck do
    url :stable
    regex(/href=.*?readline[._-]v?(\d+(?:\.\d+)+)\.t/i)
    strategy :gnu do |page, regex|
      # Match versions from files
      versions = page.scan(regex)
                     .flatten
                     .uniq
                     .map { |v| Version.new(v) }
                     .sort
      next versions if versions.blank?

      # Assume the last-sorted version is newest
      newest_version = versions.last

      # Simply return the found versions if there isn't a patches directory
      # for the "newest" version
      patches_directory = page.match(%r{href=.*?(readline[._-]v?#{newest_version.major_minor}[._-]patches/?)["' >]}i)
      next versions if patches_directory.blank?

      # Fetch the page for the patches directory
      patches_page = Homebrew::Livecheck::Strategy.page_content(
        "https://ftp.gnu.org/gnu/readline/#{patches_directory[1]}",
      )
      next versions if patches_page[:content].blank?

      # Generate additional major.minor.patch versions from the patch files in
      # the directory and add those to the versions array
      patches_page[:content].scan(/href=.*?readline[._-]?v?\d+(?:\.\d+)*[._-]0*(\d+)["' >]/i).each do |match|
        versions << "#{newest_version.major_minor}.#{match[0]}"
      end

      versions
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a517cb70e4efb6a1d061fc5da61aefd9390b86fbe21024cef18b5697f5f7af94"
    sha256 cellar: :any,                 arm64_sonoma:  "875c8524ef5514ba0368040d2355fce741ef00206c214a661d5bec1e66979b38"
    sha256 cellar: :any,                 arm64_ventura: "e63fe588d7dc5ddf30351150c325be8dbd474e20d469a1632542bcf62531000f"
    sha256 cellar: :any,                 sequoia:       "f4e77a529e80700170d7de8f1cea5e7773e8fbadfab69669465761170f8f0b47"
    sha256 cellar: :any,                 sonoma:        "f861e9241d7b5b53457a64f45cd128be2bca6c93c4769caba1dc7ca04c7f8eed"
    sha256 cellar: :any,                 ventura:       "ed7497b20408ad2447e3451adcff05133bc07c8a56f49b6ea0fae730919e49ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d2c6882b7c79962109f46af7855600d157508be3ffba9f29af442dc337829bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9fedfb81316e643182df350f4861dcde21bb2d19f0f533ec9a76b03754ba07dd"
  end

  keg_only :shadowed_by_macos, "macOS provides BSD libedit"

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-curses"
    # FIXME: Setting `SHLIB_LIBS` should not be needed, but, on Linux,
    #        many dependents expect readline to link with ncurses and
    #        are broken without it. Readline should be agnostic about
    #        the terminfo library on Linux.
    system "make", "install", "SHLIB_LIBS=-lcurses"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <stdlib.h>
      #include <readline/readline.h>

      int main()
      {
        printf("%s\\n", readline("test> "));
        return 0;
      }
    C

    system ENV.cc, "-L", lib, "test.c", "-L#{lib}", "-lreadline", "-o", "test"
    assert_equal "test> Hello, World!\nHello, World!", pipe_output("./test", "Hello, World!\n").strip
  end
end