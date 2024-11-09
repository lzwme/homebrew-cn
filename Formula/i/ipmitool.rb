class Ipmitool < Formula
  desc "Utility for IPMI control with kernel driver or LAN interface"
  homepage "https:codeberg.orgIPMIToolipmitool"
  url "https:codeberg.orgIPMIToolipmitoolarchiveIPMITOOL_1_8_19.tar.gz"
  sha256 "ce13c710fea3c728ba03a2a65f2dd45b7b13382b6f57e25594739f2e4f20d010"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(^IPMITOOL[._-]v?(\d+(?:[._]\d+)+)$i)
    strategy :git do |tags, regex|
      tags.map { |tag| tag[regex, 1]&.tr("_", ".") }
    end
  end

  bottle do
    sha256 arm64_sequoia: "edbce0fa9c0eb8554d49e69266b9a954b48675511ae98cab9f252df858c60feb"
    sha256 arm64_sonoma:  "4209c292804d02871d7ffbb5eacfe3d0a9b4c433bd7ea324d7411453e5898ed8"
    sha256 arm64_ventura: "d5f56eab1fc400e5160b2e08df8161d8d8c0bfeb9935ed220ae28e60ab6f460c"
    sha256 sonoma:        "6486e5cfbef27dc3affea78d2ce0d06b50b44030e27606095f25ad9f42dafce7"
    sha256 ventura:       "b232ea31418c3291675268781731b137e2d5737e3e588c46508bc5c7c9bcc3ce"
    sha256 x86_64_linux:  "610caf753fee4dcb908b7213554bb2397a9e303c00c95b52a7168da42ba804f7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "readline"
  end

  # Patch to fix lan print
  # https:github.comipmitoolipmitoolissues388
  patch do
    url "https:github.comipmitoolipmitoolcommita61349b443c16821e4884cde5ad8c031d619631a.patch?full_index=1"
    sha256 "e026b8a5a5128714a0f36d05b4b26428dca3522dc889ebc21dc8888a2d3f1505"
  end

  # Patch to fix enterprise-number URL due to IANA URL scheme change
  # https:github.comipmitoolipmitoolissues377
  patch do
    url "https:codeberg.orgIPMIToolipmitoolcommit1edb0e27e44196d1ebe449aba0b9be22d376bcb6.patch?full_index=1"
    sha256 "044363a930cf6a9753d8be2a036a0ee8c4243ce107eebc639dcb93e1e412e0ed"
  end

  # Patch to fix build on ARM
  # https:github.comipmitoolipmitoolissues332
  patch do
    url "https:codeberg.orgIPMIToolipmitoolcommit206dba615d740a31e881861c86bcc8daafd9d5b1.patch?full_index=1"
    sha256 "86eba5d0000b2d1f3ce3ba4a23ccb5dd762d01fec0f9910a95e756c5399d7fb8"
  end

  def install
    system ".bootstrap"
    system ".configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--disable-intf-usb"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}ipmitool -V")
    if OS.mac?
      assert_match "No hostname specified!", shell_output("#{bin}ipmitool 2>&1", 1)
    else # Linux
      assert_match "Could not open device", shell_output("#{bin}ipmitool 2>&1", 1)
    end
  end
end