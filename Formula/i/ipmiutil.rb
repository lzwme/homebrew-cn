class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.2.0.tar.gz"
  sha256 "3e2ddb6d3c1ee6ae6d8e965b3b425006b84bc2106779593716a9597cc4b70a76"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "GPL-2.0-or-later"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4f5162d5ec6bab445102d17eb74785cac015ed46e95c1ded3ae1eb1d6e611a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "721ef573958fcbd45a94557ce1c37c39e6aa315c9cd0b444b5799eb295b1b002"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "328a48d84b68902882e1ff129ecfaeb8034cd7136e59b94552270c54b5a30970"
    sha256 cellar: :any_skip_relocation, sonoma:        "369ca869caf600fa1545f69dbf739e8b52a991459e1985ecf7fbdde631d27ae4"
    sha256 cellar: :any_skip_relocation, ventura:       "e2f10503928d08da8438a3ae4672d79520fe4a4b00a03bac4b061919471f197e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8935945b50b9b31c07486faa025117f1b50c88d179801b9a1dbb0b2d83cc178"
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