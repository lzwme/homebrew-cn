class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.43.tar.bz2"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.43.tar.bz2"
  sha256 "fed3c3077f0df7a4a1aa47b080b8c53277593ccbb4e5e78b73ffb4e3f265e750"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256                               arm64_sonoma:   "233c35be9292afff371b5abfd5415cb1c0e41ef88bfcd572f047d2c6f2cb4a24"
    sha256                               arm64_ventura:  "3f99d6fed435ca62a140763e0dd979acd2e2425ca8ebca260510a0293aa492b6"
    sha256                               arm64_monterey: "4e75b842b0c6242848ef8984e3125a458594cbe9b23e1f97b154a8ad2018227e"
    sha256                               sonoma:         "db41dcf85cae9752a3b6cb4dff665715fd3a056257ef77abcac26e810e2f0ccb"
    sha256                               ventura:        "6dded0d11e13fb06d927d899fbdd308d0b9b0f26fd77af4a4992d9229676ecd1"
    sha256                               monterey:       "e60c7c6459b4fb98585dd84d92b2bb5f8d4071ce744511d5f75a398b6ffd2b80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec06c7983ba81f3e59c8f4db1645eb19f3edfa12fb5a86e65689bfd6ceda10dc"
  end

  keg_only "it shadows the host toolchain"

  depends_on "pkg-config" => :build
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "zlib"

  link_overwrite "bin/gold"
  link_overwrite "bin/ld.gold"
  link_overwrite "bin/dwp"

  def install
    # Workaround https://sourceware.org/bugzilla/show_bug.cgi?id=28909
    touch "gas/doc/.dirstamp", mtime: Time.utc(2022, 1, 1)
    make_args = OS.mac? ? [] : ["MAKEINFO=true"] # for gprofng

    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-deterministic-archives",
      "--prefix=#{prefix}",
      "--infodir=#{info}",
      "--mandir=#{man}",
      "--disable-werror",
      "--enable-interwork",
      "--enable-multilib",
      "--enable-64-bit-bfd",
      "--enable-gold",
      "--enable-plugins",
      "--enable-targets=all",
      "--with-system-zlib",
      "--with-zstd",
      "--disable-nls",
    ]
    system "./configure", *args
    system "make", *make_args
    system "make", "install", *make_args

    if OS.mac?
      Dir["#{bin}/*"].each do |f|
        bin.install_symlink f => "g" + File.basename(f)
      end
    else
      bin.install_symlink "ld.gold" => "gold"
      # Reduce the size of the bottle.
      bin_files = bin.children.select(&:elf?)
      system "strip", *bin_files, *lib.glob("*.a")
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end