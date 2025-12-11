class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-3.9.2.src.tar.xz"
  sha256 "3f988b0923b323d2d25d642f0f749fbfa59194a9fc18c86e224d5caaa2399c5e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9d1793b0118c773b6cac6d21158741320175bba5be37cd01cf5c4a45a25661c0"
    sha256 cellar: :any,                 arm64_sequoia: "c7281f565f164191641d872e90c53777da14c599322c15e53a109566dbc193fc"
    sha256 cellar: :any,                 arm64_sonoma:  "3f958e46799dc8d40e0adbbf51530eb47a22b309e0ea3610f9ba7514a71b2f2b"
    sha256 cellar: :any,                 sonoma:        "8c64b3710304784c46ea3c7d5bf30b3ca91254176c93b0e70dbd8b668eab33b6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "73ff6e32fd968895db590cb78e0cc9d05c0ed0c35a87dad142de8306211e664e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33a5a2397b4b9fd4bd3dedf20f0a7bee2acb93445683b7684a1bcb8df6caf27f"
  end

  depends_on "gawk" => :build
  depends_on "libb64" => :build
  depends_on "dcmtk"
  depends_on "suite-sparse"

  def install
    ENV.append "CXX", "-std=gnu++17"

    # Work around header include order causing issues with `#ifndef isfinite`
    ENV.append "CXXFLAGS", "-include cmath" if DevelopmentTools.clang_build_version >= 1700

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    ENV.deparallelize if OS.mac? && MacOS.version >= :sonoma
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end