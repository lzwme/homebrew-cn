class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.2.2.tar.gz"
  sha256 "37f9bc8e6b18c1155e4d5ea38c87b83908b7acc7a44fbc5e3af493f26ef8b767"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "GPL-2.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0543ef166694a3176b20726c875ff72c40d4b4cd8d39503b73adda3f8d749f90"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "950e34d0adbc6225563c0e59c379c4ca31dc420ecff1daaf86cdef8135ae1223"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "836fe8e01b7a3b9daf59ba36f19d0f05532fc23dec0b1b776cbc324ea11e90e1"
    sha256 cellar: :any,                 arm64_linux:       "32df0f70e51973220ced2b72392c01ac59819088bcdcac57e0053bcd2d0eb9b7"
    sha256 cellar: :any,                 x86_64_linux:      "c3feb63ed9d9e4e81dc831d01aedf1cf0245ea3320712947fd7934bfbf1a4997"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "renameutils", because: "both install `icmd` binaries"

  def install
    # Workaround for newer Clang
    ENV.append "CC", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403
    # autoconf 2.73 selects C23, which rejects the implicit declarations in this codebase
    ENV["ac_cv_prog_cc_c23"] = "no"

    # Darwin does not exist only on PowerPC
    if OS.mac?
      inreplace "configure.ac", "test \"$archp\" = \"powerpc\"", "true"
      system "autoreconf", "--force", "--install", "--verbose"
    end

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-lanplus",
                          "--enable-sha256",
                          "--enable-gpl"

    system "make", "TMPDIR=#{ENV["TMPDIR"]}"
    # DESTDIR is needed to make everything go where we want it.
    system "make", "prefix=/",
                   "DESTDIR=#{prefix}",
                   "varto=#{var}/lib/#{name}",
                   "initto=#{etc}/init.d",
                   "sysdto=#{prefix}/#{name}",
                   "install"
  end

  test do
    system bin/"ipmiutil", "delloem", "help"
  end
end