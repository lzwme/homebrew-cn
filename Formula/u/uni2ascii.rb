class Uni2ascii < Formula
  desc "Bi-directional conversion between UTF-8 and various ASCII flavors"
  homepage "https:billposer.orgSoftwareuni2ascii.html"
  url "http:billposer.orgSoftwareDownloadsuni2ascii-4.20.tar.bz2"
  sha256 "0c5002f54b262d937ba3a8249dd3148791a3f6ec383d80ec479ae60ee0de681a"
  license "GPL-3.0-only"

  livecheck do
    url :homepage
    regex(href=.*?uni2ascii[._-]v?(\d+(?:\.\d+)+)\.ti)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d3a472d2c31cfa9dc963c26fe7f15d7a3f782a937d7026c4ad59bbd986729af5"
    sha256 cellar: :any,                 arm64_ventura:  "2e92a28331236f4d0a7a3f14a2be9acfe64f4fcc61394a8e0eba9211c1a4415d"
    sha256 cellar: :any,                 arm64_monterey: "12397160ce567ec3d0d101b0028c9c962d82a0861873bbc0172492d975dfb3ac"
    sha256 cellar: :any,                 sonoma:         "1290b690baabd758c09160b9c252713672e53765064840e03c6c0369e28c555b"
    sha256 cellar: :any,                 ventura:        "e017fd2d8f72748c1359d02c265e0a9c8f12e8cd37dfe58170ccb0de7d1a8c1b"
    sha256 cellar: :any,                 monterey:       "5f6b3ece8272dde8a0d191ca12151aa4b56c9afb6e3fa90d5d5d0db0024941d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc233e02cdbc8f3cb9dfe84c213d8b6eb3650f2102d85050ea412b93c5bf94eb"
  end

  on_macos do
    depends_on "gettext"
  end

  # notified upstream about this patch
  patch do
    url "https:raw.githubusercontent.comHomebrewformula-patchesbb92449ad6b3878b4d6f472237152df28080df86uni2asciiuni2ascii-4.20.patch"
    sha256 "250a529eda136d0edf9e63b92a6fe95f4ef5dfad3f94e6fd8d877138ada857f8"
  end

  def install
    if OS.mac?
      gettext = Formula["gettext"]
      ENV.append "CFLAGS", "-I#{gettext.include}"
      ENV.append "LDFLAGS", "-L#{gettext.lib}"
      ENV.append "LDFLAGS", "-lintl"
    end

    ENV["MKDIRPROG"]="mkdir -p"

    system ".configure", *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"
  end

  test do
    # uni2ascii
    assert_equal "0x00E9", pipe_output("#{bin}uni2ascii -q", "é")

    # ascii2uni
    assert_equal "e\n", pipe_output("#{bin}ascii2uni -q", "0x65")
  end
end