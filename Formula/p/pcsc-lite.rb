class PcscLite < Formula
  desc "Middleware to access a smart card using SCard API"
  homepage "https://pcsclite.apdu.fr/"
  url "https://pcsclite.apdu.fr/files/pcsc-lite-2.0.1.tar.bz2"
  sha256 "5edcaf5d4544403bdab6ee2b5d6c02c6f97ea64eebf0825b8d0fa61ba417dada"
  license all_of: ["BSD-3-Clause", "GPL-3.0-or-later", "ISC"]

  livecheck do
    url "https://pcsclite.apdu.fr/files/"
    regex(/href=.*?pcsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e69b5ee55f8722ca29f1677c0c9789a0bde57759689b78814ea3ee2df9855a51"
    sha256 cellar: :any,                 arm64_ventura:  "19c4716a366ee4de280345b15e11e05bdee39a4393c084cc19d2a0a245121657"
    sha256 cellar: :any,                 arm64_monterey: "2aea1e033298ad17b66f49c6258e325c03d6d17a5dfd28100305a69d4e36680a"
    sha256 cellar: :any,                 sonoma:         "2e88a05fb8d19a7e6e1b79199feb3b7d126944c73ee5fa73e6871b75a0ee1f3e"
    sha256 cellar: :any,                 ventura:        "ae6ad65c38fa737309a27a55796254adad295ce12094b6aeba0c8983c60e3f6b"
    sha256 cellar: :any,                 monterey:       "74ee27d36ada74a818796b9d42b9d567587e16e0b6f4fe945dc6cd90d781a71c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "437ba27784bd24b2202c9d637eaaf0285ef90a746ddf32f3d4498aaa6a65c4f0"
  end

  keg_only :shadowed_by_macos, "macOS provides PCSC.framework"

  uses_from_macos "flex" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libusb"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --disable-libsystemd
      --disable-polkit
    ]

    args << "--disable-udev" if OS.linux?

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"pcscd", "--version"
  end
end