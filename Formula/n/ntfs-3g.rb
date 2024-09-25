class Ntfs3g < Formula
  desc "Read-write NTFS driver for FUSE"
  homepage "https:www.tuxera.comcommunityopen-source-ntfs-3g"
  url "https:tuxera.comopensourcentfs-3g_ntfsprogs-2022.10.3.tgz"
  sha256 "f20e36ee68074b845e3629e6bced4706ad053804cbaf062fbae60738f854170c"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.0-or-later"]

  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, x86_64_linux: "3fe3041e69391706e917d335a8d6bebd1dd502126e5d19e4b0fabded9a3e40f7"
  end

  head do
    url "https:github.comtuxerantfs-3g.git", branch: "edge"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libgcrypt" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "coreutils" => :test
  depends_on "gettext"
  depends_on "libfuse@2"
  depends_on :linux # on macOS, requires closed-source macFUSE

  def install
    args = std_configure_args + %W[
      --exec-prefix=#{prefix}
      --mandir=#{man}
      --with-fuse=external
      --enable-extras
      --disable-ldconfig
    ]

    system ".autogen.sh" if build.head?
    # Workaround for hardcoded sbin
    inreplace Dir["{ntfsprogs,src}Makefile.in"], "$(DESTDIR)sbin", "$(DESTDIR)#{sbin}"
    system ".configure", *args
    system "make"
    system "make", "install"

    # Install a script that can be used to enable automount
    File.open("#{sbin}mount_ntfs", File::CREAT|File::TRUNC|File::RDWR, 0755) do |f|
      f.puts <<~EOS
        #!binbash

        VOLUME_NAME="${@:$#}"
        VOLUME_NAME=${VOLUME_NAME#Volumes}
        USER_ID=#{Process.uid}
        GROUP_ID=#{Process.gid}

        if [ "$(usrbinstat -f %u devconsole)" -ne 0 ]; then
          USER_ID=$(usrbinstat -f %u devconsole)
          GROUP_ID=$(usrbinstat -f %g devconsole)
        fi

        #{opt_bin}ntfs-3g \\
          -o volname="${VOLUME_NAME}" \\
          -o local \\
          -o negative_vncache \\
          -o auto_xattr \\
          -o auto_cache \\
          -o noatime \\
          -o windows_names \\
          -o streams_interface=openxattr \\
          -o inherit \\
          -o uid="$USER_ID" \\
          -o gid="$GROUP_ID" \\
          -o allow_other \\
          -o big_writes \\
          "$@" >> varlogmount-ntfs-3g.log 2>&1

        exit $?;
      EOS
    end
  end

  test do
    # create a small raw image, format and check it
    ntfs_raw = testpath"ntfs.raw"
    system Formula["coreutils"].libexec"gnubintruncate", "--size=10M", ntfs_raw
    ntfs_label_input = "Homebrew"
    system sbin"mkntfs", "--force", "--fast", "--label", ntfs_label_input, ntfs_raw
    system bin"ntfsfix", "--no-action", ntfs_raw
    ntfs_label_output = shell_output("#{sbin}ntfslabel #{ntfs_raw}")
    assert_match ntfs_label_input, ntfs_label_output
  end
end