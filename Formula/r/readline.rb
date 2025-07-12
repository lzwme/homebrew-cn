class Readline < Formula
  desc "Library for command-line editing"
  homepage "https://tiswww.case.edu/php/chet/readline/rltop.html"
  url "https://ftp.gnu.org/gnu/readline/readline-8.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/readline/readline-8.3.tar.gz"
  version "8.3.1"
  sha256 "fe5383204467828cd495ee8d1d3c037a7eba1389c22bc6a041f627976f9061cc"
  license "GPL-3.0-or-later"

  # Add new patches using this format:
  #
  # patch_checksum_pairs = %w[
  #   001 <checksum for <major>.<minor>.1>
  #   002 <checksum for <major>.<minor>.2>
  #   ...
  # ]

  patch_checksum_pairs = %w[
    001 21f0a03106dbe697337cd25c70eb0edbaa2bdb6d595b45f83285cdd35bac84de
  ]

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
    sha256 cellar: :any,                 arm64_sequoia: "3afa0c228ce704810d09d40ce7d1265777df8b9034a7bfc18f0f4c19094710a8"
    sha256 cellar: :any,                 arm64_sonoma:  "51a9a7122a89fd2464fc631f8c31721afc700b3b220ed8b0c23655514b04db73"
    sha256 cellar: :any,                 arm64_ventura: "5788e1e5f713d5253edfc4b9d137d384b692fee6de1c79af3dba18fa7efd31c3"
    sha256 cellar: :any,                 sequoia:       "85d56c6896ac184bf38b1b0867d050235fb0a4873c152b52a46748aa1b458ec9"
    sha256 cellar: :any,                 sonoma:        "1ca59c2fba1ae707b3c893bc237c6638c5140fd73795e76fb186b1176b5931ff"
    sha256 cellar: :any,                 ventura:       "722187db867ece23e06d6e1ce4b67190d602e2b456e113a9b3c5e3930de923d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64ab04c378cb3546baef10c3804ce5c1f3ec70a293df98b8e48b674e123c28b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "148c40946804e22da82f0864b458d1eb01f23b9cf30c7b9f10501853b92ad33a"
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