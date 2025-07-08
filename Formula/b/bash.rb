class Bash < Formula
  desc "Bourne-Again SHell, a UNIX command interpreter"
  homepage "https://www.gnu.org/software/bash/"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/bash.git", branch: "master"

  stable do
    url "https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz"
    mirror "https://ftpmirror.gnu.org/bash/bash-5.3.tar.gz"
    mirror "https://mirrors.kernel.org/gnu/bash/bash-5.3.tar.gz"
    mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.3.tar.gz"
    sha256 "62dd49c44c399ed1b3f7f731e87a782334d834f08e098a35f2c87547d5dbb269"

    # Add new patches using this format:
    #
    # patch_checksum_pairs = %w[
    #   001 <checksum for 5.3.1>
    #   002 <checksum for 5.3.2>
    #   ...
    # ]

    patch_checksum_pairs = %w[]

    patch_checksum_pairs.each_slice(2) do |p, checksum|
      patch :p0 do
        url "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/bash53-#{p}"
        mirror "https://ftpmirror.gnu.org/bash/bash-5.3-patches/bash53-#{p}"
        mirror "https://mirrors.kernel.org/gnu/bash/bash-5.3-patches/bash53-#{p}"
        mirror "https://mirrors.ocf.berkeley.edu/gnu/bash/bash-5.3-patches/bash53-#{p}"
        sha256 checksum
      end
    end
  end

  # We're not using `url :stable` here because we need `url` to be a string
  # when we use it in the `strategy` block.
  livecheck do
    url "https://ftp.gnu.org/gnu/bash/?C=M&O=D"
    regex(/href=.*?bash[._-]v?(\d+(?:\.\d+)+)\.t/i)
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
      patches_directory = page.match(%r{href=.*?(bash[._-]v?#{newest_version.major_minor}[._-]patches/?)["' >]}i)
      next versions if patches_directory.blank?

      # Fetch the page for the patches directory
      patches_page = Homebrew::Livecheck::Strategy.page_content(URI.join(@url, patches_directory[1]).to_s)
      next versions if patches_page[:content].blank?

      # Generate additional major.minor.patch versions from the patch files in
      # the directory and add those to the versions array
      patches_page[:content].scan(/href=.*?bash[._-]?v?\d+(?:\.\d+)*[._-]0*(\d+)["' >]/i).each do |match|
        versions << "#{newest_version.major_minor}.#{match[0]}"
      end

      versions
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "0cb8fa2fef54f0215e01137dae12119af693da6f9d468c8eb882c979dcee91a0"
    sha256 arm64_sonoma:  "fe8e711dbad1902aea7b1237a93addb1cbd4fd643144ee2fa860800972e15b8d"
    sha256 arm64_ventura: "d97833da4ac2bce736f63168162707cdaa3c57547e63b2ef39c2500be4e2a4b9"
    sha256 sonoma:        "03e937973106a6bce6cf3830e6cc21b48250bfd79c0b93899404328008296d68"
    sha256 ventura:       "0afa527fcb68b0182c63f395ac25474e42d90c7dae8e009c4c8a4c8a1baa20ee"
    sha256 arm64_linux:   "3bc02cf84788f354c443bd15218b2bdacbce4fcd4364852afed1caf2a25ef30c"
    sha256 x86_64_linux:  "505c5c1260fe9a3a7251baa06dc0acecd0274bdda4686edb04202385523279e6"
  end

  depends_on "gettext"
  # System ncurses lacks functionality
  # https://github.com/Homebrew/homebrew-core/issues/158667
  depends_on "ncurses"

  def bash_loadables_path
    [
      "#{HOMEBREW_PREFIX}/lib/bash",
      # Stock Bash paths; keep them for backwards compatibility.
      "/usr/local/lib/bash",
      "/usr/lib/bash",
      "/opt/local/lib/bash",
      "/usr/pkg/lib/bash",
      "/opt/pkg/lib/bash",
      ".",
    ].uniq.join(":")
  end

  def install
    # When built with SSH_SOURCE_BASHRC, bash will source ~/.bashrc when
    # it's non-interactively from sshd.  This allows the user to set
    # environment variables prior to running the command (e.g. PATH).  The
    # /bin/bash that ships with macOS defines this, and without it, some
    # things (e.g. git+ssh) will break if the user sets their default shell to
    # Homebrew's bash instead of /bin/bash.
    ENV.append_to_cflags "-DSSH_SOURCE_BASHRC"

    ENV.append_to_cflags "-DDEFAULT_LOADABLE_BUILTINS_PATH='\"#{bash_loadables_path}\"'"

    system "./configure", "--prefix=#{prefix}", "--with-curses", "--without-included-gettext"
    system "make", "install"

    (include/"bash/builtins").install lib/"bash/loadables.h"
    pkgshare.install lib.glob("bash/Makefile*")
  end

  def caveats
    "DEFAULT_LOADABLE_BUILTINS_PATH: #{bash_loadables_path}"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/bash -c 'echo -n hello'")
    # If the following assertion breaks, then it's likely the configuration of `DEFAULT_LOADABLE_BUILTINS_PATH`
    # is broken. Changing the test below will probably hide that breakage.
    assert_equal "csv is a shell builtin\n", shell_output("#{bin}/bash -c 'enable csv; type csv'")
  end
end