class ScummvmTools < Formula
  desc "Collection of tools for ScummVM"
  homepage "https:www.scummvm.org"
  url "https:downloads.scummvm.orgfrsscummvm-tools2.7.0scummvm-tools-2.7.0.tar.xz"
  sha256 "1d9f1faf8338a2fda64f0e6e14bc25a2dadced156cb28a9c60191b983d72db71"
  license "GPL-3.0-or-later"
  revision 7
  head "https:github.comscummvmscummvm-tools.git", branch: "master"

  livecheck do
    url "https:www.scummvm.orgdownloads"
    regex(href=.*?scummvm-tools[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "62f494b25b1d871cfd1adedea60f08745c1b1b58902c6d0ff2c9520ded8a1988"
    sha256 cellar: :any,                 arm64_sonoma:  "fbad749c989a532104b08938c53117116564aaa3e4e9466f76cd440e7fff557f"
    sha256 cellar: :any,                 arm64_ventura: "cc7a1b2104be3e291b0dfc20c0b80ba2c642543d5751d4b6703e77df9d52b38b"
    sha256 cellar: :any,                 sonoma:        "75023d89b1af5e90cd8e7ceb1b8f5cb9ead37cf7d791025964966d45e855ad21"
    sha256 cellar: :any,                 ventura:       "8f1484d030e356c9bb478ecab34bb118ec806adc862d9710b53e87df8f237de1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0de41429c253dedcca6b68cb98da410d82803fadb3f32e1f25c6ce41912c426"
  end

  depends_on "boost"
  depends_on "flac"
  depends_on "freetype"
  depends_on "libogg"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "wxwidgets"

  uses_from_macos "zlib"

  def install
    # configure will happily carry on even if it can't find wxwidgets,
    # so let's make sure the install method keeps working even when
    # the wxwidgets dependency version changes
    wxwidgets = deps.find { |dep| dep.name.match?(^wxwidgets(@\d+(\.\d+)?)?$) }
                    .to_formula

    # The configure script needs a little help finding our wx-config
    wxconfig = "wx-config-#{wxwidgets.version.major_minor}"
    inreplace "configure", ^_wxconfig=wx-config$, "_wxconfig=#{wxconfig}"

    system ".configure", "--enable-verbose-build", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match <<~EOS, shell_output("#{bin}scummvm-tools-cli --list")
      All available tools:
      \tcompress_agos:	Compresses Simon the Sorcerer and Feeble Files data files.
      \tcompress_gob:	Compresses Gobliiins! data files.
      \tcompress_kyra:	Used to compress Legend of Kyrandia games.
      \tcompress_queen:	Used to compress Flight of the Amazon Queen data files.
    EOS

    assert_match version.to_s, shell_output("#{bin}scummvm-tools-cli --version")
  end
end