class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https:www.gnu.orgsoftwarecoreutils"
  url "https:ftp.gnu.orggnucoreutilscoreutils-9.6.tar.xz"
  mirror "https:ftpmirror.gnu.orgcoreutilscoreutils-9.6.tar.xz"
  sha256 "7a0124327b398fd9eb1a6abde583389821422c744ffa10734b24f557610d3283"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "7bf380e4ce9771ce6f030f3719385c06e88f84370181d93f9648570b11387179"
    sha256 arm64_sonoma:  "8c7f7842f107875e1e34a86b111a8a555d4c4c7a462384efb2ca2fc8dc4b1e65"
    sha256 arm64_ventura: "660a337982d5823866a3fa1a96176a02be60ed36e60b11f3d2daddda36070edc"
    sha256 sonoma:        "39905d59ea233abe321d959141ae14a8abd28d94fa06e8b92c64c886b630febd"
    sha256 ventura:       "f3a168a88b2e1c90be1e8281927f9b6fcf74c19ab391477af859d7a01d8696ae"
    sha256 arm64_linux:   "7c00b70363d68afd160edab9acc5b09abee3588b329c0c8f76d6333cb26ed13f"
    sha256 x86_64_linux:  "3735c0172cd6a0679f3dc2b37f5b1b4f55fd290fa48ab07231f55e898be6fe69"
  end

  head do
    url "https:git.savannah.gnu.orggitcoreutils.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "gettext" => :build
    depends_on "texinfo" => :build
    depends_on "wget" => :build
    depends_on "xz" => :build
  end

  depends_on "gmp"
  uses_from_macos "gperf" => :build

  on_macos do
    conflicts_with "uutils-coreutils", because: "coreutils and uutils-coreutils install the same binaries"
  end

  on_sonoma :or_older do
    conflicts_with "md5sha1sum", because: "both install `md5sum` and `sha1sum` binaries"
  end

  on_linux do
    depends_on "acl"
    depends_on "attr"
  end

  conflicts_with "b2sum", because: "both install `b2sum` binaries"
  conflicts_with "gfold", because: "both install `gfold` binaries"
  conflicts_with "idutils", because: "both install `gid` and `gid.1`"

  # https:github.comHomebrewhomebrew-corepull36494
  def breaks_macos_users
    %w[dir dircolors vdir]
  end

  def install
    ENV.runtime_cpu_detection
    system ".bootstrap" if build.head?

    args = %W[
      --prefix=#{prefix}
      --program-prefix=g
      --with-libgmp
      --without-selinux
    ]

    system ".configure", *args
    system "make", "install"

    no_conflict = if OS.mac?
      []
    else
      %w[
        b2sum base32 basenc chcon dir dircolors factor hostid md5sum nproc numfmt pinky ptx realpath runcon
        sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf stdbuf tac timeout truncate vdir
      ]
    end

    # Symlink all commands into libexecgnubin without the 'g' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec"gnubin").install_symlink bin"g#{cmd}" => cmd

      # Find non-conflicting commands on macOS
      which_cmd = which(cmd)
      no_conflict << cmd if OS.mac? && (which_cmd.nil? || !which_cmd.to_s.start_with?(%r{(usr)?s?bin}))
    end
    # Symlink all man(1) pages into libexecgnuman without the 'g' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec"gnuman""man1").install_symlink man1"g#{cmd}" => cmd
    end
    (libexec"gnubin").install_symlink "..gnuman" => "man"

    no_conflict -= breaks_macos_users if OS.mac?
    # Symlink non-conflicting binaries
    no_conflict.each do |cmd|
      bin.install_symlink "g#{cmd}" => cmd
      man1.install_symlink "g#{cmd}.1" => "#{cmd}.1"
    end
  end

  def caveats
    msg = "Commands also provided by macOS and the commands #{breaks_macos_users.join(", ")}"
    on_linux do
      msg = "All commands"
    end
    <<~EOS
      #{msg} have been installed with the prefix "g".
      If you need to use these commands with their normal names, you can add a "gnubin" directory to your PATH with:
        PATH="#{opt_libexec}gnubin:$PATH"
    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(^g, "")
    end
    filenames.sort
  end

  test do
    (testpath"test").write("test")
    (testpath"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin"gsha1sum", "-c", "test.sha1"
    system bin"gln", "-f", "test", "test.sha1"
  end
end