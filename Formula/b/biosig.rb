class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.5.2.src.tar.xz"
  sha256 "3c87fa4ae6d69e1a75477f85451b6f16480418a0018d59e1586a2e3e8954ec47"
  license "GPL-3.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3563a68a4ab81df2e3bf406f1ea07165bd97d5f250f9329eaafc5d75d4142b77"
    sha256 cellar: :any,                 arm64_monterey: "177a67a16d08aa6a2b8b22b0dcc8151f31413d155e4b3847032ff74476193b5a"
    sha256 cellar: :any,                 ventura:        "8c9176d1daea2120afc5f0af93df47a0a736f6f310fb2b45e4a996dcbbec90db"
    sha256 cellar: :any,                 monterey:       "984b14283113635f806cf6738518a577ce7c9356f1bc70d2074c5cf68791d576"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a57b3148d7f626270537bae6d17a623919bdf1bdf80845b812c142e07ef9af23"
  end

  depends_on "gawk" => :build
  depends_on "libarchive" => :build
  depends_on "dcmtk"
  depends_on "libb64"
  depends_on "numpy"
  depends_on "suite-sparse"
  depends_on "tinyxml2"

  def install
    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end