class Coreutils < Formula
  desc "GNU File, Shell, and Text utilities"
  homepage "https://www.gnu.org/software/coreutils/"
  url "https://ftpmirror.gnu.org/gnu/coreutils/coreutils-9.11.tar.xz"
  mirror "https://ftp.gnu.org/gnu/coreutils/coreutils-9.11.tar.xz"
  sha256 "394024eda0a5955217ceda9cd1201e65dc8fa3aa29c2951135a49521d57c3cc3"
  license "GPL-3.0-or-later"
  compatibility_version 1

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "e008e0990f4faac93ea80c84d883ebf86cdd6c5c35d4d1563188ee669632aa04"
    sha256 arm64_tahoe:       "1d83338bdaa5e88791ee93827c7c3300e53ebec1f49a7457ea2423c738640f09"
    sha256 arm64_sequoia:     "ca348f4f13dd894e18d144376c089f284ceaa6057ddb3ef619c21854ffe676dd"
    sha256 arm64_sonoma:      "2e43c4567c18397e01cbc420b9b3517f1e7413eb06a6f8035e2b9e66d533483e"
    sha256 tahoe:             "977efb0a453a9925357946303a3c65082ebc0730f909fbda4a1cda8fcbbc8ba5"
    sha256 sequoia:           "dc73c410c602bd1a311d70d3ba5a196d768ff0c89c64dd9db0635b8df52249f2"
    sha256 sonoma:            "db6408fe1fba42dd98d6bfa1743c3428eacaf86ff8908dc10364c64b2c192490"
    sha256 arm64_linux:       "687d582969ecd08dcaf9c495aa68322125f3c43492917af8c2f1537afae2a2e1"
    sha256 x86_64_linux:      "a8b81719a9e729f94c5396e88a943d7cec9ccc5c9abf926e6ff7860948e25aee"
  end

  head do
    url "https://git.savannah.gnu.org/git/coreutils.git", branch: "master"

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

  # https://github.com/Homebrew/homebrew-core/pull/36494
  def breaks_macos_users
    %w[dir dircolors vdir]
  end

  deny_network_access!

  def install
    ENV.runtime_cpu_detection
    system "./bootstrap" if build.head?

    args = %w[
      --program-prefix=g
      --with-libgmp
      --without-selinux
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    no_conflict = if OS.mac?
      []
    else
      %w[
        b2sum base32 basenc chcon dir dircolors factor hostid md5sum nproc numfmt pinky ptx realpath runcon
        sha1sum sha224sum sha256sum sha384sum sha512sum shred shuf stdbuf tac timeout truncate vdir
      ]
    end

    # Symlink all commands into libexec/gnubin without the 'g' prefix
    coreutils_filenames(bin).each do |cmd|
      (libexec/"gnubin").install_symlink bin/"g#{cmd}" => cmd

      # Find non-conflicting commands on macOS
      which_cmd = which(cmd)
      no_conflict << cmd if OS.mac? && (which_cmd.nil? || !which_cmd.to_s.start_with?(%r{(/usr)?/s?bin}))
    end
    # Symlink all man(1) pages into libexec/gnuman without the 'g' prefix
    coreutils_filenames(man1).each do |cmd|
      (libexec/"gnuman/man1").install_symlink man1/"g#{cmd}" => cmd
    end
    (libexec/"gnubin").install_symlink "../gnuman" => "man"

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
        PATH="#{opt_libexec}/gnubin:$PATH"
    EOS
  end

  def coreutils_filenames(dir)
    filenames = []
    dir.find do |path|
      next if path.directory? || path.basename.to_s == ".DS_Store"

      filenames << path.basename.to_s.sub(/^g/, "")
    end
    filenames.sort
  end

  test do
    (testpath/"test").write("test")
    (testpath/"test.sha1").write("a94a8fe5ccb19ba61c4c0873d391e987982fbbd3 test")
    system bin/"gsha1sum", "-c", "test.sha1"
    system bin/"gln", "-f", "test", "test.sha1"
  end
end